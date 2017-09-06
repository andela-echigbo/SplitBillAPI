class Api::BillsController < Api::BaseController
  before_action :set_bill, only: %i(update destroy)

  def index
    render json: current_user.bills_including_split
  end

  def create
    @bill = current_user.bills.build(bill_params)
    render json: @bill, status: 201 and return if @bill.save

    render json: @bill.errors.full_messages, status: 400
  end

  def show
    @bill = current_user.bills_including_split.find_by(id: params[:id])
    render_with_not_found('Bill') and return unless @bill

    render json: @bill, status: 200
  end

  def update
    @bill.udpate(bill_params)
    render json: @bill, status: 200
  end

  def destroy
    @bill.destroy
    render json: { message: 'Bill deleted successfully' }, status: 200
  end

  private

  def set_bill
    @bill = current_user.bills.find_by(id: params[:id])
    render_with_not_found('Bill') unless @bill
  end

  def bill_params
    params.permit(:amount, :title, :description, :date, splitters: [])
  end
end
