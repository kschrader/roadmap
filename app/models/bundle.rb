class Bundle
  include MongoMapper::Document

  friendly_id :name

  key :name,          String, required: true  

  def estimates_total
    all_features = Feature.where(bundle_ids: self.id).all
    @total=0
    all_features.each do |f| 
        if f.estimate == nil
        elsif f.estimate >= 0
          @total= @total + f.estimate
        end
      end  
    @total
  end

  def unestimated_total 
    all_features = Feature.where(bundle_ids: self.id).all
    @total=0
    all_features.each do |f|
        if f.estimate == nil
        @total= @total + 1
        end
      end  
    @total
  end


end