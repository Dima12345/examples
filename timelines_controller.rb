# frozen_string_literal: true

module Api
  module V1
    module Users
      module Profile
        class TimelinesController < Users::BaseController
          def index
            render_response ::Timelines::Users::Profile::List.call(current_user, user), view: :normal
          end

          private

          def user
            User.find(params[:user_id])
          end
        end
      end
    end
  end
end
