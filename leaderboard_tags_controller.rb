# frozen_string_literal: true

module Api
  module V1
    module Users
      module Profile
        class LeaderboardTagsController < Users::BaseController
          def index
            render_response ::LeaderboardTags::Users::Profile::List.call(current_user, user, params),
                            view: :user_selected
          end

          def create
            render_response ::LeaderboardTags::Users::Profile::Creator.call(current_user, user, params), view: :normal
          rescue RelationAlreadyExistError
            raise RelationAlreadyExistError
          end

          def destroy
            render_response ::LeaderboardTags::Users::Profile::Destructor.call(current_user, user, tag),
                            view: :normal
          end

          private

          def tag
            @tag ||= LeaderboardTag.find(params[:id])
          end

          def user
            User.find(params[:user_id])
          end
        end
      end
    end
  end
end
