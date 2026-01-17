# Create levels
puts "Creating levels..."
levels = [
  { level_number: 1, name: "Beginner", points_required: 0 },
  { level_number: 2, name: "Explorer", points_required: 100 },
  { level_number: 3, name: "Enthusiast", points_required: 300 },
  { level_number: 4, name: "Achiever", points_required: 600 },
  { level_number: 5, name: "Master", points_required: 1000 },
  { level_number: 6, name: "Guru", points_required: 1500 },
  { level_number: 7, name: "Legend", points_required: 2500 },
  { level_number: 8, name: "Champion", points_required: 4000 },
  { level_number: 9, name: "Hero", points_required: 6000 },
  { level_number: 10, name: "Superhero", points_required: 10000 }
]

levels.each do |level_attrs|
  Level.find_or_create_by!(level_attrs)
end

# Create achievements
puts "Creating achievements..."
achievements = [
  # Points-based achievements
  { name: "First Steps", description: "Earn your first 50 points", achievement_type: "points", points_required: 50, threshold: 1 },
  { name: "Getting Started", description: "Earn 200 points", achievement_type: "points", points_required: 200, threshold: 1 },
  { name: "On a Roll", description: "Earn 500 points", achievement_type: "points", points_required: 500, threshold: 1 },
  { name: "Dedicated", description: "Earn 1000 points", achievement_type: "points", points_required: 1000, threshold: 1 },
  { name: "Expert", description: "Earn 2000 points", achievement_type: "points", points_required: 2000, threshold: 1 },
  { name: "Master", description: "Earn 5000 points", achievement_type: "points", points_required: 5000, threshold: 1 },
  
  # Project-based achievements
  { name: "Project Creator", description: "Create your first project", achievement_type: "projects_created", threshold: 1 },
  { name: "Project Manager", description: "Create 5 projects", achievement_type: "projects_created", threshold: 5 },
  { name: "Project Director", description: "Create 10 projects", achievement_type: "projects_created", threshold: 10 },
  
  # Task-based achievements
  { name: "Task Master", description: "Complete 10 tasks", achievement_type: "tasks_completed", threshold: 10 },
  { name: "Productivity Ninja", description: "Complete 50 tasks", achievement_type: "tasks_completed", threshold: 50 },
  { name: "Efficiency Expert", description: "Complete 100 tasks", achievement_type: "tasks_completed", threshold: 100 },
  
  # Post-based achievements
  { name: "First Post", description: "Create your first post", achievement_type: "posts_created", threshold: 1 },
  { name: "Blogger", description: "Create 5 posts", achievement_type: "posts_created", threshold: 5 },
  { name: "Author", description: "Create 20 posts", achievement_type: "posts_created", threshold: 20 },
  
  # Todo-based achievements
  { name: "Todo Completer", description: "Complete 5 todos", achievement_type: "todos_completed", threshold: 5 },
  { name: "Todo Champion", description: "Complete 25 todos", achievement_type: "todos_completed", threshold: 25 },
  { name: "Todo Master", description: "Complete 50 todos", achievement_type: "todos_completed", threshold: 50 },
  
  # Saved links achievements
  { name: "Link Collector", description: "Save 5 links", achievement_type: "links_saved", threshold: 5 },
  { name: "Link Librarian", description: "Save 20 links", achievement_type: "links_saved", threshold: 20 },
  
  # Materials achievements
  { name: "Resource Gatherer", description: "Upload 5 materials", achievement_type: "materials_uploaded", threshold: 5 },
  { name: "Resource Curator", description: "Upload 20 materials", achievement_type: "materials_uploaded", threshold: 20 }
]

achievements.each do |achievement_attrs|
  Achievement.find_or_create_by!(name: achievement_attrs[:name]) do |achievement|
    achievement.assign_attributes(achievement_attrs)
  end
end

puts "Gamification seed data created successfully!"