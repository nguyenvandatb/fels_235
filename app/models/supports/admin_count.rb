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

  def categories_by_day
    @categories_by_day ||= Category.group_by_day(:created_at).count
  end

  def words_by_day
    @words_by_day ||= Word.group_by_day(:created_at).count
  end

  def lessons_by_day
    @lessons_by_day ||= Lesson.group_by_day(:created_at).count
  end

  def users_by_day
    @users_by_day ||= User.group_by_day(:created_at).count
  end
end
