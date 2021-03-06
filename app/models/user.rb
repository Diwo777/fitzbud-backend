class User < ApplicationRecord
    before_create :generate_api_key
    has_secure_password
    before_validation :downcase_email
    has_many :friendships
    has_many :friends, :through => :friendships
    has_many :foods, dependent: :destroy

    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    
    validates :email, presence: true,
                  uniqueness: { case_sensitive: false },
                  format: VALID_EMAIL_REGEX
    

    def downcase_email
        email.downcase! if email.present?
      end
      
      
    def generate_api_key
        self.api_key = SecureRandom.hex(32)
        loop do
          if User.exists?(api_key: api_key)
            self.api_key = SecureRandom.hex(32)
          else
            break
          end
        end
    end
    
end
