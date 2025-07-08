class ApplicationController < ActionController::Base
    include Pundit::Authorization

    # Opcional: Adicione um rescue para Pundit::NotAuthorizedError
    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

    helper_method :getPage, :per_page, :sort_column, :sort_direction
    

    
    def getPage
        params[:page].nil? ? 1 : params[:page]
    end

    def per_page
        params[:per_page].blank? ? 10 : params[:per_page]
    end  

    def sort_column
        params[:sort].blank? ? "1" : params[:sort]
    end

    def sort_direction
        params[:direction].blank? ? "asc" : params[:direction]
    end     

    private

      def user_not_authorized
        flash[:alert] = t('pundit.not_authorized') # Mensagem de erro internacionalizada
        redirect_back(fallback_location: root_path)
      end
end
