class ReflectionSummarizer
  def initialize(reflections)
    @reflections = Array(reflections)
  end

  def summarize
    return nil if @reflections.empty?

    content = @reflections.map.with_index do |r, i|
      date = r.created_at.strftime("%B %d, %Y")
      "[#{i + 1}] #{date}:\n#{extract_text(r)}"
    end.join("\n\n")

    messages = [
      { role: "user", content: "Summarize these journal reflections:\n\n#{content}" }
    ]

    LlmRouter.new.chat(
      messages,
      system: <<~SYSTEM.strip
        You are a thoughtful reflection summarizer. Given journal entries,
        identify patterns, recurring themes, emotional trends, and key insights.
        Provide a concise, warm, and insightful summary in 3-4 sentences.
      SYSTEM
    )
  end

  private

  def extract_text(reflection)
    if reflection.body_json.present?
      blocks = JSON.parse(reflection.body_json)["blocks"] rescue []
      blocks.map { |b| b.dig("data", "text") }.compact.join(" ")
    elsif reflection.content.present?
      reflection.content.to_plain_text
    else
      ""
    end
  end
end
