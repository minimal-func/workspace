json.extract! @embed, :content

json.sgid @embed.attachable_sgid
json.content render(partial: "embeds/embed", locals: { embed: @embed }, formats: [:html])
