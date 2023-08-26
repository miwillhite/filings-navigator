class Address < ApplicationRecord
  STATE_ABBREVIATIONS = %w[
    AL AK AZ AR CA
    CO CT DE FL GA
    HI ID IL IN IA
    KS KY LA ME MD
    MA MI MN MS MO
    MT NE NV NH NJ
    NM NY NC ND OH
    OK OR PA RI SC
    SD TN TX UT VT
    VA WA WV WI WY
  ]

  belongs_to :addressable, polymorphic: true

  validates_inclusion_of :state, in: STATE_ABBREVIATIONS
end
