puts "Creating sample application data..."

def create_user!(email:, password:)
  User.find_or_create_by!(email: email) do |user|
    user.password = password
    user.password_confirmation = password
  end
end

def create_project!(user:, title:, closed: false)
  project = user.projects.find_or_create_by!(title: title)
  project.update!(closed: closed) if project.closed != closed
  project
end

def create_main_task!(user:, name:, planned_finish:)
  task = user.main_task || user.build_main_task
  task.update!(name: name, planned_finish: planned_finish)
end

def create_daily_metrics!(user:, day_offset:, day_rating:, energy:, mood:, reflection:, lesson:, gratitude:, challenge:)
  day = day_offset.days.ago
  timestamp = day.change(hour: 9, min: 0, sec: 0)

  DayRating.find_or_create_by!(user: user, created_at: timestamp) { |r| r.value = day_rating }
  EnergyLevel.find_or_create_by!(user: user, created_at: timestamp + 10.minutes) { |r| r.value = energy }
  Mood.find_or_create_by!(user: user, created_at: timestamp + 20.minutes) { |r| r.value = mood }
  Reflection.find_or_create_by!(user: user, created_at: timestamp + 30.minutes) { |r| r.content = reflection }
  DailyLesson.find_or_create_by!(user: user, created_at: timestamp + 40.minutes) { |r| r.content = lesson }
  DailyGratitude.find_or_create_by!(user: user, created_at: timestamp + 50.minutes) { |r| r.content = gratitude }
  BiggestChallenge.find_or_create_by!(user: user, created_at: timestamp + 60.minutes) { |r| r.content = challenge }
end

def create_project_content!(project:, tasks:, todos:, posts:, links:, materials:)
  tasks.each do |content, started_days_ago, finished_days_ago|
    attrs = { content: content, project: project }
    task = Task.find_or_create_by!(attrs)
    task.update!(
      started_at: started_days_ago&.days&.ago,
      finished_at: finished_days_ago&.days&.ago
    )
  end

  todos.each do |name, finished|
    todo = Todo.find_or_create_by!(project: project, name: name)
    todo.update!(finished: finished)
  end

  posts.each do |title, short_description, body, is_public|
    post = Post.find_or_create_by!(project: project, title: title) do |p|
      p.short_description = short_description
      p.public = is_public
    end
    post.update!(short_description: short_description, public: is_public, content: body)
  end

  links.each do |title, url, short_description|
    link = SavedLink.find_or_initialize_by(project: project, title: title)
    link.url = url
    link.short_description = short_description
    link.save!
  end

  material_lookup = {}
  materials.each do |title, short_description, parent_title, is_folder|
    parent = parent_title ? material_lookup[parent_title] : nil
    material = Material.find_or_create_by!(project: project, title: title, parent: parent) do |m|
      m.is_folder = is_folder
      m.short_description = short_description
    end
    material.update!(is_folder: is_folder, short_description: short_description)
    material_lookup[title] = material
  end
end

def create_points!(user:, actions:)
  actions.each do |value, action_name, pointable|
    Point.find_or_create_by!(user: user, value: value, action: action_name, pointable: pointable)
  end
  user.update_total_points
end

owner = create_user!(email: "demo@workspace.local", password: "password123")
teammate = create_user!(email: "teammate@workspace.local", password: "password123")

create_main_task!(
  user: owner,
  name: "Ship v1 of the weekly reflection experience",
  planned_finish: 3.weeks.from_now
)

deep_work = create_project!(user: owner, title: "Deep Work Journal")
fitness = create_project!(user: owner, title: "Fitness Reset")
learning = create_project!(user: owner, title: "AI Learning Sprint")
teammate_project = create_project!(user: teammate, title: "Career Growth Plan", closed: true)

create_project_content!(
  project: deep_work,
  tasks: [
    ["Define weekly reflection template", 9, 8],
    ["Implement streak progress card", 7, 6],
    ["Review dashboard copywriting", 3, nil]
  ],
  todos: [
    ["Publish first weekly summary", true],
    ["Add keyboard shortcuts for quick notes", false],
    ["Refine gratitude section prompts", true]
  ],
  posts: [
    [
      "Building a Better Weekly Reflection",
      "How small prompts improved consistency.",
      "I switched from one giant journal prompt to a compact set of daily prompts and completion jumped.",
      true
    ],
    [
      "What I Learned From Missing 3 Days",
      "Missed streaks can still produce useful insight.",
      "The reset strategy was to lower friction: one sentence reflections at minimum.",
      false
    ]
  ],
  links: [
    ["Atomic Habits Summary", "https://jamesclear.com/atomic-habits", "Practical habit loop ideas."],
    ["Deep Work Notes", "https://www.calnewport.com/books/deep-work/", "Reference for focused work sessions."]
  ],
  materials: [
    ["Research", "Folder for reference docs", nil, true],
    ["Prompt Library", "Folder with tested journaling prompts", "Research", true],
    ["MVP Scope", "One-page implementation plan", "Research", false],
    ["Weekly Questions v2", "Updated reflection checklist", "Prompt Library", false]
  ]
)

create_project_content!(
  project: fitness,
  tasks: [
    ["Plan 4-week workout split", 10, 9],
    ["Book baseline mobility assessment", 8, 7]
  ],
  todos: [
    ["Track sleep for 14 days", false],
    ["Prep meals every Sunday", true]
  ],
  posts: [
    [
      "Consistency Over Intensity",
      "A sustainable approach to training.",
      "Short and frequent workouts were easier to sustain than long sessions.",
      true
    ]
  ],
  links: [
    ["Zone 2 Cardio Guide", "https://www.trainingpeaks.com/blog/zone-2-training/", "Good explanation of aerobic base training."]
  ],
  materials: [
    ["Programs", "Training plans and notes", nil, true],
    ["4-Week Split", "Current training split", "Programs", false]
  ]
)

create_project_content!(
  project: learning,
  tasks: [
    ["Read 3 papers on retrieval-augmented generation", 6, 4],
    ["Prototype memory-aware prompt flow", 3, 1]
  ],
  todos: [
    ["Summarize one paper per day", false],
    ["Create architecture diagram", true]
  ],
  posts: [
    [
      "RAG Pitfalls in Small Projects",
      "Trade-offs discovered during prototyping.",
      "Index freshness mattered more than embedding model quality for our small dataset.",
      true
    ]
  ],
  links: [
    ["Attention Is All You Need", "https://arxiv.org/abs/1706.03762", "Transformer baseline paper."],
    ["OpenAI API Docs", "https://platform.openai.com/docs", "Reference for integrations."]
  ],
  materials: [
    ["Papers", "Research papers", nil, true],
    ["RAG Notes", "Implementation and testing notes", "Papers", false]
  ]
)

create_project_content!(
  project: teammate_project,
  tasks: [
    ["Define next role expectations", 15, 14]
  ],
  todos: [
    ["Update portfolio", true]
  ],
  posts: [
    [
      "Quarterly Career Retrospective",
      "Wins and gaps from the last quarter.",
      "Focused on communication and impact framing during project demos.",
      false
    ]
  ],
  links: [
    ["Resume Checklist", "https://www.themuse.com/advice/the-ultimate-checklist-to-make-your-resume-perfect", "Quick checklist before applying."]
  ],
  materials: [
    ["Interview Prep", "Folder for preparation resources", nil, true],
    ["STAR Stories", "Curated story bank", "Interview Prep", false]
  ]
)

[
  [0, 8, 7, 8, "Today I protected focus blocks and finished one high-impact task.", "Limit active priorities to 3.", "A calm morning walk.", "Too many notifications during deep work."],
  [1, 7, 8, 7, "Yesterday was productive once I stopped context switching.", "Schedule email windows instead of continuous checks.", "A supportive teammate review.", "Scope creep on side tasks."],
  [2, 6, 6, 6, "Energy dipped after lunch, but I still shipped the minimum plan.", "Plan hard tasks before noon.", "An uninterrupted coding session.", "Late-night sleep affected attention."]
].each do |entry|
  create_daily_metrics!(
    user: owner,
    day_offset: entry[0],
    day_rating: entry[1],
    energy: entry[2],
    mood: entry[3],
    reflection: entry[4],
    lesson: entry[5],
    gratitude: entry[6],
    challenge: entry[7]
  )
end

sample_actions = [
  [25, "project_created", deep_work],
  [25, "project_created", fitness],
  [25, "project_created", learning],
  [10, "task_completed", deep_work.tasks.first],
  [10, "task_completed", fitness.tasks.first],
  [10, "task_completed", learning.tasks.first],
  [8, "todo_completed", deep_work.todos.where(finished: true).first],
  [8, "todo_completed", fitness.todos.where(finished: true).first],
  [12, "post_created", deep_work.posts.first]
]

create_points!(user: owner, actions: sample_actions)

puts "Sample application data created successfully!"
