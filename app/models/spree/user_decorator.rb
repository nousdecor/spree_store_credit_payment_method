# NOTE: Remove for 3-1-stable

module SpreeStoreCredits::UserDecorator
  def self.included(base)
    base.has_many :store_credits, -> { includes(:credit_type) }, foreign_key: "user_id", class_name: "Spree::StoreCredit"
    base.has_many :store_credit_events, through: :store_credits

    base.prepend(InstanceMethods)
  end

  module InstanceMethods
    def total_available_store_credit
      store_credits.reload.to_a.sum{ |credit| credit.amount_remaining }
    end
  end
end

Spree.user_class.include SpreeStoreCredits::UserDecorator
