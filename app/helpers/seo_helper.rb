module SeoHelper
  def meta_title(default = nil)
    if content_for?(:title)
      content_for(:title)
    elsif default.present?
      default
    elsif @app_title.present?
      "MyDay.#{@app_title}"
    else
      "MyDay — Daily Productivity, Wellbeing & Reflection System"
    end
  end

  def meta_description(default = nil)
    if content_for?(:meta_description)
      content_for(:meta_description)
    elsif default.present?
      default
    else
      "MyDay helps you build a life that feels lighter, calmer, and more meaningful. Track your mood, energy, gratitude, and direction in one daily system."
    end
  end

  def meta_keywords(default = nil)
    if content_for?(:meta_keywords)
      content_for(:meta_keywords)
    elsif default.present?
      default
    else
      "productivity app, wellbeing tracker, daily reflection, mood tracker, energy tracking, gratitude journal, habit tracker, daily planner, personal growth, happiness framework"
    end
  end

  def meta_robots(default = nil)
    if content_for?(:meta_robots)
      content_for(:meta_robots)
    elsif default.present?
      default
    elsif private_page?
      "noindex, nofollow, noarchive"
    else
      "index, follow, max-image-preview:large, max-snippet:-1, max-video-preview:-1"
    end
  end

  def canonical_url(default = nil)
    if content_for?(:canonical_url)
      content_for(:canonical_url)
    elsif default.present?
      default
    else
      path = request.path
      path = "/" if path == "/landing"
      path = "" if path == "/"
      "https://#{app_host}#{path}"
    end
  end

  def og_image_url(default = nil)
    if content_for?(:og_image)
      content_for(:og_image)
    elsif default.present?
      default
    else
      "https://#{app_host}/og-image.png"
    end
  end

  def app_host
    ENV.fetch("APP_HOST", "myday.ildarsafin.tech")
  end

  def json_ld_structured_data
    return if private_page?

    schemas = []

    # WebSite Schema
    schemas << {
      "@context" => "https://schema.org",
      "@type" => "WebSite",
      "name" => "MyDay",
      "alternateName" => ["MyDay App", "MyDay Productivity"],
      "url" => "https://#{app_host}/",
      "description" => "Daily system for wellbeing, mood tracking, personal productivity, and habit reflection.",
      "inLanguage" => "en-US",
      "creator" => {
        "@type" => "Person",
        "name" => "Ildar Safin",
        "url" => "https://ildarsafin.tech"
      }
    }

    # WebApplication Schema for home / landing
    if request.path.in?(["/", "/landing"])
      schemas << {
        "@context" => "https://schema.org",
        "@type" => "WebApplication",
        "name" => "MyDay",
        "applicationCategory" => "ProductivityApplication",
        "operatingSystem" => "Web, iOS, Android",
        "url" => "https://#{app_host}/",
        "image" => og_image_url,
        "description" => "MyDay helps you build a life that feels lighter, calmer, and more meaningful by tracking mood, energy, gratitude, and direction in one place.",
        "offers" => {
          "@type" => "Offer",
          "price" => "0",
          "priceCurrency" => "USD"
        },
        "author" => {
          "@type" => "Person",
          "name" => "Ildar Safin",
          "url" => "https://ildarsafin.tech"
        },
        "featureList" => [
          "Daily Mood and Energy Tracking",
          "Gratitude Journal",
          "Daily Challenge and Learning Log",
          "Project and Todo Management",
          "Time Tracking",
          "Knowledge Hub",
          "Gamification and Habit Streaks"
        ]
      }
    end

    # FAQ Schema for help page
    if request.path == "/help"
      schemas << {
        "@context" => "https://schema.org",
        "@type" => "FAQPage",
        "mainEntity" => [
          {
            "@type" => "Question",
            "name" => "What is MyDay and what is it for?",
            "acceptedAnswer" => {
              "@type" => "Answer",
              "text" => "MyDay is a system designed around awareness, reflection, and action. It helps you track your emotional state, protect your energy, practice gratitude, and connect daily routines to meaningful projects."
            }
          },
          {
            "@type" => "Question",
            "name" => "How do I use MyDay daily?",
            "acceptedAnswer" => {
              "@type" => "Answer",
              "text" => "Start with the Dashboard to set your intention and main task. Track your mood, energy, and alignment in under a minute, log one key challenge, record one lesson learned, and write one gratitude."
            }
          },
          {
            "@type" => "Question",
            "name" => "How do projects and time tracking work in MyDay?",
            "acceptedAnswer" => {
              "@type" => "Answer",
              "text" => "Projects give your meaningful work a home. Break projects into todos, track time on focused sessions, write project reflection posts, and organize reference materials and links."
            }
          },
          {
            "@type" => "Question",
            "name" => "How does gamification work in MyDay?",
            "acceptedAnswer" => {
              "@type" => "Answer",
              "text" => "You earn points and level up by completing check-ins, tasks, and reflections. Leveling up unlocks advanced features such as time tracking, project posts, saved links, knowledge search, and materials."
            }
          }
        ]
      }
    end

    tags = schemas.map do |schema|
      content_tag(:script, schema.to_json.html_safe, type: "application/ld+json")
    end

    safe_join(tags, "\n")
  end

  private

  def private_page?
    # Non-authenticated public pages
    public_paths = ["/", "/landing", "/help", "/waiting_list/new", "/waiting_list"]
    return false if request.path.in?(public_paths)

    # If user is signed in or in authenticated controllers
    return true if respond_to?(:user_signed_in?) && user_signed_in?

    # Auth controllers or internal pages
    private_controllers = %w[
      dashboards reflections day_ratings energy_levels moods
      biggest_challenges daily_lessons daily_gratitudes main_task
      gamification chatgpt knowledge notifications embeds
      sessions passwords registrations confirmations unlocks
    ]
    controller_name.in?(private_controllers) || controller_path.start_with?("timetracker/", "projects/", "admin/", "users/")
  end
end
