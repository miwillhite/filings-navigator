class Filer < ApplicationRecord
  belongs_to :filing
  has_one :address, as: :addressable, dependent: :destroy

  scope :filter_by_state, -> (state) { joins(:address).where('address.state': state) }

  def as_json(options = {})
    super(options).merge(
      filer_state: address.state
    )
  end
end
