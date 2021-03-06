class Company < ActiveRecord::Base
  has_many :company_people, dependent: :destroy
    accepts_nested_attributes_for :company_people

  has_many :jobs

  has_many :addresses, as: :location, dependent: :destroy
    accepts_nested_attributes_for :addresses

  has_and_belongs_to_many :agencies


  validates :ein,   :ein_number => true
  validates :phone, :phone => true
  validates :email, :email => true
  validates :website, :website => true
  validates_presence_of :name

  STATUS = { PND:   'Pending Registration', # Company has registered but not yet approved
             ACT:   'Active',
             INACT: 'Inactive',
             DENY:  'Registration Denied'}

  validates :status, inclusion: STATUS.values

end
