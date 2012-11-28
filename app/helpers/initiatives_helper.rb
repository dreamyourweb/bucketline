module InitiativesHelper
	def initiatives_to_sentence(initiatives)
		sentence = []
		initiatives.each do |initiative|
			if initiative
				sentence << initiative.name
			end
		end
		sentence.to_sentence
	end
end
