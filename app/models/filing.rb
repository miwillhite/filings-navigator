class Filing < ApplicationRecord
  has_one :filer
  has_many :participants
  has_many :awards, through: :participants

  scope :by_filer, ->(filer_id) { joins(:filer).where('filer.id': filer_id) }

  def as_json(options = {})
    super(options).merge(
      filer_id: filer.id
    )
  end
end
