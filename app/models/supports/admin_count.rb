class Supports::AdminCount
  def categories_count
    @categories_count ||= Category.select(:id).size
  end

  def words_count
    @words_count ||= Word.select(:id).size
  end

  def lessons_count
    @lessons_count ||= Lesson.select(:id).size
  end

  def users_count
    @users_count ||= User.select(:id).size
  end
end
