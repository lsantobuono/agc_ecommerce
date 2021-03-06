module Spree
  module Admin
    BookkeepingDocumentsController.class_eval do
      def index
        # Massaging the params for the index view like Spree::Admin::Orders#index
        params[:q] ||= {}
        @search = Spree::BookkeepingDocument.ransack(params[:q])
        @bookkeeping_documents = @search.result
        @bookkeeping_documents = @bookkeeping_documents.where(printable: @order) if order_focused?
        @bookkeeping_documents = @bookkeeping_documents.order("created_at desc").take(1)
        @order_events = %w{approve cancel resume}
  #      @bookkeeping_documents = @bookkeeping_documents.page(params[:page] || 1).per(10)
      end

      def show
        respond_with(@bookkeeping_document) do |format|
          format.pdf do
            send_data @bookkeeping_document.pdf, type: 'application/pdf', disposition: 'attachment', filename: "#{@bookkeeping_document.printable.number}.pdf"
          end
        end
      end

    end 
  end
end
