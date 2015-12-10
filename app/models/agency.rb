class Agency < ActiveRecord::Base
  has_many :agency_people
  has_many :branches
  has_and_belongs_to_many :companies
  
  validates_presence_of :name, :website, :phone, :email
  validates_length_of   :name, maximum: 100
  validates_length_of   :website, maximum: 200
  validates :phone, :phone => true
  validates :email, :email => true
  validates :website, :website => true
  validates :fax, :phone => true, allow_blank: true
  
  # For the following methods, 'logged_in_user' can be either an
  # AgencyPerson object, or the User object associated with an AgencyPerson
  # In either case, this object needs to represent:
  #   an AgencyPerson object (directly or via user.actable), and,
  #   that person must be logged in
  
  def self.agency_admins(logged_in_user)
    find_users_with_role(logged_in_user, AgencyRole::ROLE[:AA])
  end
  
  def self.this_agency(logged_in_user)
    raise RuntimeError, 'Logged in user is not an agency person' unless
            logged_in_user.actable.is_a? AgencyPerson
            
    Agency.find(logged_in_user.actable.agency_id)
  end
  
  private
  
  def self.find_users_with_role(logged_in_user, role)
    return nil if not logged_in_user
    
    users = []
    this_agency(logged_in_user).agency_people.each do |ap|
      users << ap if ap.agency_roles && 
                     ap.agency_roles.pluck(:role).include?(role)
    end
    users
  end
  
end
