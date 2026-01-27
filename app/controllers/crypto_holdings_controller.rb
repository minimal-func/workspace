class CryptoHoldingsController < ApplicationController
  before_action :authenticate_user!

  def index
    @crypto_holdings = CryptoPortfolioService.new(current_user).holdings
    @total_cost = @crypto_holdings.sum(&:total_cost)
    @total_value = @crypto_holdings.sum(&:current_value)
    @total_profit_loss = @total_value - @total_cost
    @total_profit_loss_percentage = if @total_cost.positive?
                                      (@total_profit_loss / @total_cost) * 100
                                    elsif @total_profit_loss.positive?
                                      100.0
                                    elsif @total_profit_loss.negative?
                                      -100.0
                                    else
                                      0.0
                                    end

    @erc20_activity = current_user.crypto_transactions.order(block_timestamp: :desc).limit(50)
  end

  def update_wallet
    if current_user.update(eth_wallet_params)
      CryptoSyncService.sync_for_user(current_user) if current_user.eth_wallet_address.present?
      redirect_to crypto_holdings_path, notice: 'Wallet address updated and portfolio synced.'
    else
      redirect_to crypto_holdings_path, alert: 'Failed to update wallet address.'
    end
  end

  def sync_wallet
    if current_user.eth_wallet_address.present?
      CryptoSyncService.sync_for_user(current_user)
      redirect_to crypto_holdings_path, notice: 'Portfolio synced from wallet.'
    else
      redirect_to crypto_holdings_path, alert: 'Please set your wallet address first.'
    end
  end

  private

  def eth_wallet_params
    params.require(:user).permit(:eth_wallet_address)
  end
end
