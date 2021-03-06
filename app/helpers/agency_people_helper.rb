module AgencyPeopleHelper
  def disable_agency_admin?(agency_person, role)

    # Disable the check_box for the agency admin role if this person
    # is the sole admin for the agency (return true to disable).

    return false unless role == AgencyRole::ROLE[:AA]
    agency_person.sole_agency_admin?
  end

  def eligible_job_seekers_for_role(agency_person, role_key)
    # Returns array of job seekers that are:
    #   1) Unassigned to any agency_person in the given role, or,
    #   2) Are already assigned to this agency_person in this role

    # NOTE: this logic assumes *one* agency in the system - will need
    # refactoring if we extend to multiple agencies per instance

    seekers = []
    JobSeeker.all.each do |job_seeker|
      # Seekers not assigned to any person in this role
      seekers << job_seeker if job_seeker.agency_relations.in_role_of(role_key).empty?
    end

    role_id = AgencyRole.find_by_role(AgencyRole::ROLE[role_key]).id

    agency_person.agency_relations.each do |relation|
      # Seekers already assigned to this person in this role
      seekers << relation.job_seeker if relation.agency_role_id == role_id
    end
    seekers
  end
end
