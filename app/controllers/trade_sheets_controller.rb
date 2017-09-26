class TradeSheetsController < ApplicationController
  before_action :set_trade_sheet, only: [:show, :edit, :update, :destroy]

  # GET /trade_sheets
  # GET /trade_sheets.json
  def index
    @trade_sheets = TradeSheet.all
  end

  # GET /trade_sheets/1
  # GET /trade_sheets/1.json
  def show
  end

  # GET /trade_sheets/new
  def new
    @trade_sheet = TradeSheet.new
  end

  # GET /trade_sheets/1/edit
  def edit
  end

  # POST /trade_sheets
  # POST /trade_sheets.json
  def create
    @trade_sheet = TradeSheet.new(trade_sheet_params)

    respond_to do |format|
      if @trade_sheet.save
        format.html { redirect_to @trade_sheet, notice: 'Trade sheet was successfully created.' }
        format.json { render :show, status: :created, location: @trade_sheet }
      else
        format.html { render :new }
        format.json { render json: @trade_sheet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /trade_sheets/1
  # PATCH/PUT /trade_sheets/1.json
  def update
    respond_to do |format|
      if @trade_sheet.update(trade_sheet_params)
        format.html { redirect_to @trade_sheet, notice: 'Trade sheet was successfully updated.' }
        format.json { render :show, status: :ok, location: @trade_sheet }
      else
        format.html { render :edit }
        format.json { render json: @trade_sheet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /trade_sheets/1
  # DELETE /trade_sheets/1.json
  def destroy
    @trade_sheet.destroy
    respond_to do |format|
      format.html { redirect_to trade_sheets_url, notice: 'Trade sheet was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_trade_sheet
      @trade_sheet = TradeSheet.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def trade_sheet_params
      params.require(:trade_sheet).permit(:week, :league_id)
    end
end
