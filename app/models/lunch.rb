class Lunch < ActiveRecord::Base
  belongs_to :genre
  belongs_to :restaurant
  has_many :lunch_comments
   
  before_save :arrangeDummyComments
  before_destroy :ensure_not_referenced_by_any_lunch_comment

    attr_accessible :name, :price, :genre_id, :restaurant_id, :withdrink, :image
    mount_uploader :image,ImageUploader
  
  # --------------------------------------------------------
  # �ۊǑO�ɃR�����g��0����������_�~�[��}������
  # �_�~�[�������ă_�~�[�ȊO������΃_�~�[���폜����
  # --------------------------------------------------------
  def arrangeDummyComments
    if lunch_comments.empty?
      self.createDummyComment()
    end
    self.removeDummy()
  end

  # --------------------------------------------------------
  # �_�~�[�������ă_�~�[�ȊO������΃_�~�[���폜����
  # --------------------------------------------------------
  def removeDummy
    dummy = self.findDummy
    if !(dummy.nil?) && (self.lunch_comments.size() > 1)
      #self.lunch_comments.delete(dummy)
      dummy.destroy()
    end
  end
  
  # --------------------------------------------------------
  # �_�~�[�R�����g�����
  # --------------------------------------------------------
  def createDummyComment
      newComment = self.lunch_comments.new()
      newComment.text = self.labelForDummy
      newComment.name = ' '
      newComment.rating_id = 0
      newComment.save()
  end

  # --------------------------------------------------------
  # �_�~�[�R�����g�p�̃R�����g��
  # --------------------------------------------------------
  def labelForDummy
    'no comment'
  end
  
  # --------------------------------------------------------
  # �_�~�[�R�����g��T��
  # --------------------------------------------------------
  def findDummy
    self.lunch_comments.each do | com |
      if com.text == labelForDummy
        return com
      end
    end
    return nil
  end
  
  private
  
  def ensure_not_referenced_by_any_lunch_comment
    if lunch_comments.empty?
      return true
    else
      errors.add(:base, 'This lunch has lunch_comments')
      return false
    end
  end
end
