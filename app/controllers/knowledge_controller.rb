class KnowledgeController < ApplicationController
  def index
    @stats = knowledge_stats
    @recent_items = recent_knowledge_items
    @ai_insight = generate_insight
  end

  def search
    @query = params[:query]
    @results = search_knowledge(@query) if @query.present?
    render partial: "knowledge/results" if params[:partial]
  end

  private

  def knowledge_stats
    user = current_user
    {
      reflection_count: user.reflections.count,
      gratitude_count: user.daily_gratitudes.count,
      lesson_count: user.daily_lessons.count,
      challenge_count: user.biggest_challenges.count,
      post_count: Post.joins(:project).where(projects: { user_id: user.id }).count,
      link_count: SavedLink.joins(:project).where(projects: { user_id: user.id }).count,
      material_count: Material.joins(:project).where(projects: { user_id: user.id }).count,
      total_entries: user.reflections.count + user.daily_gratitudes.count +
                     user.daily_lessons.count + user.biggest_challenges.count +
                     Post.joins(:project).where(projects: { user_id: user.id }).count +
                     SavedLink.joins(:project).where(projects: { user_id: user.id }).count +
                     Material.joins(:project).where(projects: { user_id: user.id }).count,
      record_days: user.reflections.select(:created_at).distinct.count
    }
  end

  def recent_knowledge_items
    items = []

    user = current_user

    user.reflections.order(created_at: :desc).limit(5).each do |r|
      items << {
        type: "reflection",
        title: "Reflection",
        preview: r.content&.to_plain_text&.truncate(120) || r.body_json&.dig("blocks", 0, "data", "text")&.truncate(120),
        date: r.created_at,
        path: reflections_path,
        icon: "icon-Pen"
      }
    end

    user.daily_gratitudes.order(created_at: :desc).limit(3).each do |g|
      items << {
        type: "gratitude",
        title: "Gratitude",
        preview: g.content&.truncate(120),
        date: g.created_at,
        path: daily_gratitudes_path,
        icon: "icon-Heart"
      }
    end

    user.daily_lessons.order(created_at: :desc).limit(3).each do |l|
      items << {
        type: "lesson",
        title: "Lesson Learned",
        preview: l.content&.truncate(120),
        date: l.created_at,
        path: daily_lessons_path,
        icon: "icon-Light-Bulb"
      }
    end

    user.biggest_challenges.order(created_at: :desc).limit(3).each do |c|
      items << {
        type: "challenge",
        title: "Challenge",
        preview: c.content&.truncate(120),
        date: c.created_at,
        path: biggest_challenges_path,
        icon: "icon-Flag"
      }
    end

    Post.joins(:project).where(projects: { user_id: user.id }).order("posts.created_at DESC").limit(5).each do |p|
      items << {
        type: "post",
        title: p.title,
        preview: p.short_description&.truncate(120),
        date: p.created_at,
        path: project_post_path(p.project, p),
        icon: "icon-Newspaper"
      }
    end

    SavedLink.joins(:project).where(projects: { user_id: user.id }).order("saved_links.created_at DESC").limit(5).each do |l|
      items << {
        type: "link",
        title: l.title,
        preview: l.short_description&.truncate(120),
        date: l.created_at,
        path: project_saved_links_path(l.project),
        icon: "icon-Link"
      }
    end

    items.sort_by { |i| i[:date] }.reverse.first(20)
  end

  def search_knowledge(query)
    user = current_user
    results = []

    like_query = "%#{query}%"

    user.reflections.where("body_json::text ILIKE ?", like_query).limit(5).each do |r|
      results << {
        type: "reflection",
        title: "Reflection",
        preview: r.body_json&.dig("blocks", 0, "data", "text")&.truncate(120),
        date: r.created_at,
        path: reflections_path,
        icon: "icon-Pen"
      }
    end

    user.daily_gratitudes.where("content ILIKE ?", like_query).limit(5).each do |g|
      results << { type: "gratitude", title: "Gratitude", preview: g.content&.truncate(120), date: g.created_at, path: daily_gratitudes_path, icon: "icon-Heart" }
    end

    user.daily_lessons.where("content ILIKE ?", like_query).limit(5).each do |l|
      results << { type: "lesson", title: "Lesson Learned", preview: l.content&.truncate(120), date: l.created_at, path: daily_lessons_path, icon: "icon-Light-Bulb" }
    end

    user.biggest_challenges.where("content ILIKE ?", like_query).limit(5).each do |c|
      results << { type: "challenge", title: "Challenge", preview: c.content&.truncate(120), date: c.created_at, path: biggest_challenges_path, icon: "icon-Flag" }
    end

    Post.joins(:project).where(projects: { user_id: user.id }).where("posts.title ILIKE ? OR posts.short_description ILIKE ?", like_query, like_query).order("posts.created_at DESC").limit(5).each do |p|
      results << { type: "post", title: p.title, preview: p.short_description&.truncate(120), date: p.created_at, path: project_post_path(p.project, p), icon: "icon-Newspaper" }
    end

    results.sort_by { |i| i[:date] }.reverse.first(15)
  end

  def generate_insight
    user = current_user
    recent_reflections = user.reflections.order(created_at: :desc).limit(7)

    return nil if recent_reflections.empty?

    reflection_texts = recent_reflections.map do |r|
      r.body_json&.dig("blocks")&.map { |b| b.dig("data", "text") }&.compact&.join(" ")
    end.compact

    return nil if reflection_texts.empty?

    {
      type: %w[pattern question reminder theme].sample,
      title: "Your Second Brain noticed something",
      message: "You have #{reflection_texts.size} recent reflections. Patterns are emerging in your thinking — keep capturing to reveal them."
    }
  end
end
