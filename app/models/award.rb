class Award < ApplicationRecord
  belongs_to :recipient

  scope :by_filing, ->(filing_id) { joins(:recipient).where('recipient.filing_id': filing_id) }

  scope :filter_by_cash_amount, -> (min:, max:) do
    result = where('amount_in_dollars > ?', min.present? ? min : 0)
    if (max.present?)
      result.where('amount_in_dollars < ?', max)
    else
      result
    end
  end

  def as_json(options = {})
    super(options).merge(
      filing_id: recipient.filing_id
    )
  end
end
