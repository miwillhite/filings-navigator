class Recipient < ApplicationRecord
  belongs_to :filing
  has_many :awards, dependent: :destroy
  has_one :address, as: :addressable, dependent: :destroy

  scope :filter_by_state, -> (state) { joins(:address).where('address.state': state) }

  scope :filter_by_cash_amount, -> (min:, max:) do
    result = joins(:awards).where('awards.amount_in_dollars > ?', min.present? ? min : 0)
    if (max.present?)
      result.where('amount_in_dollars < ?', max)
    else
      result
    end
  end

  scope :filter_by_filing, -> (filing_id) { where(filing_id:) }

  def as_json(options = {})
    super(options).merge(
      state: address&.state,
      award_amount_in_dollars: awards.map(&:amount_in_dollars).to_sentence,
    )
  end
end
