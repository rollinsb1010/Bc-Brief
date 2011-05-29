class Project < ActiveRecord::Base
  has_one :company
  has_many :milestones
  default_scope :order => 'sort_order ASC'  
  validates_uniqueness_of :bc_id
  
  def media_milestones
    
    filtered_milestones = Array.new
    
    Milestone::presets.each do |preset|
      filtered_milestones << Milestone.find_or_initialize_by_project_id_and_title(id,preset)
    end
    
    return filtered_milestones
    
  end
  

  def self.update_cache(url,username,password)

    cache = CacheUpdate.find_or_initialize_by_username(username)
    cache.updated = Time.now
    cache.save
    
    # connect to basecamp and find all of the projects
    Basecamp.establish_connection!(url,username,password,true)
    Basecamp::Project.find(:all).each do |bc_project|

      project = Project.find_or_initialize_by_bc_id(bc_project.id)
      project.bc_id = bc_project.id
      project.name = bc_project.name
      project.status = bc_project.status

      if !project.company
        Company.create! do |company|
          company.name = bc_project.company.name
        end
        project.company = company
      end

      Basecamp::Milestone.list(project.bc_id).each do |bc_milestone|
        milestone = Milestone.find_or_initialize_by_id(bc_milestone.id)
        milestone.title = bc_milestone.title
        milestone.deadline = bc_milestone.deadline
        milestone.completed = bc_milestone.completed.to_s
        project.milestones << milestone
      end
      
      project.save

    end

  end
  
end
