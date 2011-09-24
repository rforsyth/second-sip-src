
module Enums
	
	class EnumBase
		def self.enum_name(type)
			self.collection.each_pair do |key, value|
				return key if value == type
			end
			return nil
		end
		
		def self.sorted_collection
		  self.collection.sort{ |a,b| a[1] <=> b[1] }
		end
	end
  
  class Visibility < EnumBase
    PRIVATE = 10
    FRIENDS = 20
    PUBLIC = 50
    
    def self.collection
      return {
        'Private' => PRIVATE,
        'Friends' => FRIENDS,
        'Public' => PUBLIC }
    end

		def self.name(visibility)
			case visibility
			when PRIVATE then 'PRIVATE'
			when FRIENDS then 'FRIENDS'
			when PUBLIC then 'PUBLIC'
			end
		end
  end
  
  class ScoreType < EnumBase
    POINTS_100 = 100
		POINTS_50 = 50
		POINTS_20 = 20
		POINTS_10 = 10
		POINTS_5 = 5
		POINTS_4 = 4
		POINTS_3 = 3
    
    def self.collection
      return {
        '100 Point Scale' => POINTS_100,
        '50 Point Scale' => POINTS_50,
        '20 Point Scale' => POINTS_20,
        '10 Point Scale' => POINTS_10,
        '5 Point Scale' => POINTS_5,
        '4 Point Scale' => POINTS_4,
        '3 Point Scale' => POINTS_3 }
    end
  end
  
  class ReferenceProducerEntityType < EnumBase
		def self.collection
			return {
				'ReferenceBrewery' => Brewery.name,
				'ReferenceWinery' => Winery.name,
				'ReferenceDistillery' => Distillery.name }
		end
	end
  
  class ReferenceProductEntityType < EnumBase
		def self.collection
			return {
				'ReferenceBeer' => Brewery.name,
				'ReferenceWine' => Winery.name,
				'ReferenceSpirit' => Distillery.name }
		end
	end

	class BeverageEntityType < EnumBase
		def self.collection
			return {
				'Brewery' => Brewery.name,
				'Beer' => Beer.name,
				'Beer Note' => BeerNote.name,
				'Winery' => Winery.name,
				'Wine' => Wine.name,
				'Wine Note' => WineNote.name,
				'Distillery' => Distillery.name,
				'Spirit' => Spirit.name,
				'Spirit Note' => SpiritNote.name }
		end
	end

	class ReferenceBeverageEntityType < EnumBase
		def self.collection
			return {
				'ReferenceBrewery' => ReferenceBrewery.name,
				'ReferenceBeer' => ReferenceBeer.name,
				'ReferenceWinery' => ReferenceWinery.name,
				'ReferenceWine' => ReferenceWine.name,
				'ReferenceDistillery' => ReferenceDistillery.name,
				'ReferenceSpirit' => ReferenceSpirit.name }
		end
	end
	
	class EntityType < EnumBase
	  def self.collection
	    table = {}
	    BeverageEntityType.collection.each {|key, value| table[key] = value}
	    ReferenceBeverageEntityType.collection.each {|key, value| table[key] = value}
	    table['Taster'] = Taster.name
	    return table
	  end
  end
			
  class LookupType < EnumBase
    STYLE = 10
    REGION = 20
    VARIETAL = 30
    VINEYARD = 40
		OCCASION = 50
    
    def self.collection
      return {
        'Style' => STYLE,
        'Region' => REGION,
        'Varietal' => VARIETAL,
        'Vineyard' => VINEYARD,
  			'Occasion' => OCCASION }
    end
    
    def self.name(enum)
      self.collection.each_pair do |key, value|
        return key if value == enum
      end
      return nil
    end
  end	
			
  class ResourceType < EnumBase
    BJCP = 10
    WSET = 20
    WIKIPEDIA = 30
    WINE_SEARCHER = 40
    
    def self.collection
      return {
        'BJCP' => BJCP,
        'WSET' => WSET,
        'Wikipedia' => WIKIPEDIA,
        'Wine-Searcher' => WINE_SEARCHER  }
    end
  end	
			
  class FriendshipStatus < EnumBase
    REQUESTED = 10
    DECLINED = 20
    ACCEPTED = 30
    
    def self.collection
      return {
        'REQUESTED' => REQUESTED,
        'DECLINED' => DECLINED,
        'ACCEPTED' => ACCEPTED  }
    end
  end	

  class BuyWhen < EnumBase
		ANYTIME = 60
		RIGHT_SETTING = 50
		SPECIAL_OCCASION = 40
		RIGHT_PRICE = 30
		FREE = 20
		NOT_EVEN_FREE = 10
		
		def self.name(enum)
			self.collection.each_pair do |key, value|
				return key if enum == value
			end
		end
		
		def self.collection
			return {
				"Anytime it's available" => ANYTIME,
				"For the right season" => RIGHT_SETTING,
				"For a special occasion" => SPECIAL_OCCASION,
				"For the right price" => RIGHT_PRICE,
				"If it was free" => FREE,
				"Not even for free" => NOT_EVEN_FREE }
		end
		
		def self.to_tag(value)
			case value
			when ANYTIME then 'buy-anytime'
			when RIGHT_SETTING then 'buy-right-season'
			when SPECIAL_OCCASION then 'buy-special-occasion'
			when RIGHT_PRICE then 'buy-right-price'
			when FREE then 'buy-free'
			when NOT_EVEN_FREE then 'buy-not-even-free'
			else nil
			end
		end
	end
	
	
  class BeerPriceType < EnumBase
		SIX_PACK = 80
		GROWLER_64_OZ = 70
		BOTTLE_750_ML = 60
		BOTTLE_22_OZ = 50
		BOTTLE_500_ML = 40
		BOTTLE_12_OZ = 30
		BOTTLE_330_ML = 20
		BOTTLE_7_OZ = 10
		
    def self.collection
      return {
        'Six Pack' => SIX_PACK,
        '64 oz Growler' => GROWLER_64_OZ,
        '750 ml Bottle' => BOTTLE_750_ML,
        '22 oz Bottle' => BOTTLE_22_OZ,
        '500 ml Bottle' => BOTTLE_500_ML,
        '12 oz Bottle' => BOTTLE_12_OZ,
        '330 ml Bottle' => BOTTLE_330_ML,
        '7 oz Bottle' => BOTTLE_7_OZ
        }
    end
	end
	
  class WinePriceType < EnumBase
		CASE = 80
		METHUSELAH = 70
		JEROBOAM = 60
		MAGNUM = 50
		LITER = 40
		BOTTLE = 30
		HALF = 20
		SPLIT = 10
		
    def self.collection
      return {
        'Case (12)' => CASE,
        'Methuselah (8)' => METHUSELAH,
        'Jeroboam (4)' => JEROBOAM,
        'Magnum (2)' => MAGNUM,
        'Liter (1.3)' => LITER,
        'Bottle' => BOTTLE,
        'Half (1/2)' => HALF,
        'Split (1/4)' => SPLIT
        }
    end
	end
	
  class SpiritPriceType < EnumBase
		CASE = 90
		HALF_GALLON = 80
		BOTTLE_1500_ML = 70
		LITER = 60
		FIFTH = 50
		BOTTLE_500_ML = 40
		PINT = 30
		HALF_PINT = 20
		MINIATURE = 10
		
    def self.collection
      return {
        'Case (9L)' => CASE,
        '1.75 Liter' => HALF_GALLON,
        '1.5 Liter' => BOTTLE_1500_ML,
        '1 Liter' => LITER,
        '750 mL' => FIFTH,
        '500 mL' => BOTTLE_500_ML,
        '375 mL' => PINT,
        '200 mL' => HALF_PINT,
        '50 mL' => MINIATURE
        }
    end
	end
  
end
