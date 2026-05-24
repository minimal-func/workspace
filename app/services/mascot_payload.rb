class MascotPayload
  def self.project(section:, items_count:, completed_count: nil, empty_message:, project: nil, total_work_items: nil)
    new.project_payload(section: section, items_count: items_count, completed_count: completed_count,
                        empty_message: empty_message, project: project, total_work_items: total_work_items)
  end

  def self.journal(section:, items_count:)
    new.journal_payload(section: section, items_count: items_count)
  end

  def project_payload(section:, items_count:, completed_count: nil, empty_message:, project: nil, total_work_items: nil)
    completed_count ||= items_count
    total_work_items ||= project ? project.tasks.count + project.posts.count + project.todos.count + project.saved_links.count + project.materials.count : items_count

    {
      action: action_for(section),
      eyebrow: "Sunny's project desk",
      headline: project_headline(section, items_count, total_work_items, project),
      message: project_message(section, items_count, completed_count, total_work_items, empty_message),
      focus: project_focus(section, items_count, total_work_items)
    }
  end

  def journal_payload(section:, items_count:)
    config = journal_config(section)
    is_empty = items_count.zero?

    {
      action: action_for(section),
      eyebrow: config[:eyebrow],
      headline: is_empty ? config[:empty_headline] : config[:filled_headline],
      message: is_empty ? config[:empty_message] : config[:filled_message],
      focus: is_empty ? config[:empty_focus] : config[:filled_focus]
    }
  end

  private

  def project_headline(section, items_count, total_work_items, project)
    if total_work_items.zero?
      "Sunny is ready to help this project take shape"
    elsif items_count.zero?
      "Sunny is watching the next #{section.to_s.singularize}"
    else
      project_name = project&.title || "your workspace"
      "Sunny can see momentum in #{project_name}"
    end
  end

  def project_message(section, items_count, completed_count, total_work_items, empty_message)
    if items_count.zero?
      empty_message
    elsif completed_count >= items_count && items_count.positive?
      "This area is fully handled right now. Sunny suggests opening a fresh #{section.to_s.singularize} only when it moves the project forward."
    else
      "There are #{total_work_items} tracked project items in motion. Keep building the #{section} layer so work, notes, files, and references stay connected."
    end
  end

  def project_focus(section, items_count, total_work_items)
    if total_work_items.zero?
      "Start with one task or note"
    elsif items_count.zero?
      "Next move: add your first #{section.to_s.singularize}"
    else
      "Next move: grow #{section} from #{items_count}"
    end
  end

  def journal_config(section)
    {
      reflections: {
        eyebrow: "Reflect with Sunny",
        empty_headline: "Sunny is ready for your first reflection",
        filled_headline: "Sunny is holding space for your reflections",
        empty_message: "Start with one honest paragraph about what mattered today. The first entry makes the whole journal easier to return to.",
        filled_message: "Your reflections are building a real record of how your days feel, what changed, and what keeps repeating.",
        empty_focus: "Next move: write one reflection",
        filled_focus: "Next move: revisit the last reflection"
      },
      day_ratings: {
        eyebrow: "Check in with Sunny",
        empty_headline: "Sunny can help you spot the shape of a week",
        filled_headline: "Sunny is tracking the rhythm of your days",
        empty_message: "A quick rating is enough to start. Once you log a few days, patterns become much easier to notice.",
        filled_message: "These scores turn vague feelings into something visible, so it is easier to tell whether your routines are helping.",
        empty_focus: "Next move: rate today",
        filled_focus: "Next move: compare this week"
      },
      moods: {
        eyebrow: "Notice with Sunny",
        empty_headline: "Sunny is ready to map your mood patterns",
        filled_headline: "Sunny can already see your emotional landscape",
        empty_message: "Log the mood you had, not the one you think you should have had. Honest data is the useful kind.",
        filled_message: "Looking back over mood entries helps separate one hard moment from a longer trend.",
        empty_focus: "Next move: log today\u2019s mood",
        filled_focus: "Next move: look for repeats"
      },
      daily_gratitudes: {
        eyebrow: "Collect wins with Sunny",
        empty_headline: "Sunny is waiting for the first bright moment",
        filled_headline: "Sunny is gathering the good things with you",
        empty_message: "Even one small detail counts. The habit works best when the bar is low and the entry is real.",
        filled_message: "This list gives your memory something kinder to reach for when a day feels heavier than it really was.",
        empty_focus: "Next move: note one gratitude",
        filled_focus: "Next move: add today\u2019s bright spot"
      },
      daily_lessons: {
        eyebrow: "Learn with Sunny",
        empty_headline: "Sunny is ready to capture what today taught you",
        filled_headline: "Sunny is turning lived days into lessons",
        empty_message: "Write down the lesson while it is still fresh. Small conclusions are often the ones you actually reuse.",
        filled_message: "A growing lesson log makes progress easier to trust because you can see what experience has already taught you.",
        empty_focus: "Next move: record one lesson",
        filled_focus: "Next move: review a lesson you can reuse"
      },
      biggest_challenges: {
        eyebrow: "Face it with Sunny",
        empty_headline: "Sunny is here for the hard parts too",
        filled_headline: "Sunny is helping you make sense of tough days",
        empty_message: "Naming a challenge clearly is often the first useful step. You do not need a solution before you write it down.",
        filled_message: "Your challenge log shows what has been difficult, but it also proves how much you have already handled.",
        empty_focus: "Next move: name one challenge",
        filled_focus: "Next move: look for what changed"
      }
    }.fetch(section)
  end

  def action_for(section)
    self.class.action_for(section)
  end

  def self.action_for(section)
    {
      tasks: :focus,
      posts: :write,
      materials: :organize,
      links: :explore,
      reflections: :reflect,
      day_ratings: :balance,
      moods: :reflect,
      daily_gratitudes: :heart,
      daily_lessons: :learn,
      biggest_challenges: :brave
    }.fetch(section, :wave)
  end
end