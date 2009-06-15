ActiveRecord::Schema.define(:version => 1) do
  create_table "events", :force => true do |t|
    t.string "title"
    t.string "comment"
    t.text   "description"
    t.string "short_description"
  end
end
