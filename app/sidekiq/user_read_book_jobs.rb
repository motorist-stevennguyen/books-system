class UserReadBookJobs < ApplicationJob
  queue_as :book_readers

  def perform(user_id, book_id)
    book_view = BookView.new(user_id: user_id, book_id: book_id)
    book_view.save! if book_view.valid?
    puts "[users:#{user_id}_books:#{book_id}] #{book_view.errors.messages}"
  end
end
