class Event < ApplicationRecord

  before_validation :generate_friendly_id, :on => :create
  belongs_to :category, :optional => true
  has_many :tickets, :dependent => :destroy
  has_many :registrations, :dependent => :destroy
  accepts_nested_attributes_for :tickets, :allow_destroy => true, :reject_if => :all_blank

  has_many :attachments, :class_name => "EventAttachment", :dependent => :destroy
  accepts_nested_attributes_for :attachments, :allow_destroy => true, :reject_if => :all_blank
  has_many :registration_imports, :dependent => :destroy
  
  validates_presence_of :name
  STATUS = ["draft", "public", "private"]
  validates_inclusion_of :status, :in => STATUS

  scope :only_public, -> { where( :status => "public" ) }
  scope :only_available, -> { where( :status => ["public", "private"] ) }

  mount_uploader :logo, EventLogoUploader
  mount_uploaders :images, EventImageUploader
  serialize :images, JSON

  include RankedModel
  ranks :row_order

  def to_param
    self.friendly_id
  end


  def generate_friendly_id
    self.friendly_id ||= SecureRandom.uuid
  end

end
