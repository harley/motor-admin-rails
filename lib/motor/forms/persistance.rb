# frozen_string_literal: true

module Motor
  module Forms
    module Persistance
      NameAlreadyExists = Class.new(StandardError)

      module_function

      def build_from_params(params, current_user = nil)
        form = assign_attributes(Form.new, params)

        form.author = current_user

        form
      end

      def create_from_params!(params, current_user = nil)
        raise NameAlreadyExists if Form.exists?(name: params[:name])

        form = build_from_params(params, current_user)

        ApplicationRecord.transaction do
          form.save!
        end

        form
      rescue ActiveRecord::RecordNotUnique
        retry
      end

      def update_from_params!(form, params, force_replace: false)
        tag_ids = form.tags.ids

        form = assign_attributes(form, params)

        raise NameAlreadyExists if !force_replace && name_already_exists?(form)

        ApplicationRecord.transaction do
          archive_with_existing_name(form) if force_replace

          form.save!
        end

        form.touch if tag_ids.sort != form.tags.reload.ids.sort && params[:updated_at].blank?

        form
      rescue ActiveRecord::RecordNotUnique
        retry
      end

      def assign_attributes(form, params)
        form.assign_attributes(params.slice(:name, :description, :api_path, :http_method, :preferences))
        form.updated_at = [params[:updated_at], Time.current].min if params[:updated_at].present?

        Motor::Tags.assign_tags(form, params[:tags])
      end

      def archive_with_existing_name(form)
        Motor::Form.where(['name = ? AND id != ?', form.name, form.id])
                   .update_all(deleted_at: Time.current)
      end

      def name_already_exists?(form)
        if form.new_record?
          Motor::Form.exists?(['name = ?', form.name])
        else
          Motor::Form.exists?(['name = ? AND id != ?', form.name, form.id])
        end
      end
    end
  end
end
