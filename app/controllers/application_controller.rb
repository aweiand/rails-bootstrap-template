class ApplicationController < ActionController::Base
    include Pundit::Authorization

    # Opcional: Adicione um rescue para Pundit::NotAuthorizedError
    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

    private

      def user_not_authorized
        flash[:alert] = t('pundit.not_authorized') # Mensagem de erro internacionalizada
        redirect_back(fallback_location: root_path)
      end
end
