require 'csv'
require 'kmeans-clusterer'

data = []
labels = []
# Load data from CSV file into two arrays - one for latitude and longtitude data and one for labels
CSV.foreach("./data/cities.csv", :headers => false) do |row|
  labels.push( row[0] )
  data.push( [row[1].to_f, row[2].to_f] )
end


2.upto(20) do |k|
  kmeans = KMeansClusterer.run k, data, labels: labels, runs: 100
  #puts "Clusters: #{k}, Error: #{kmeans.error.round(2)}"
  puts "#{k},#{kmeans.error.round(2)}"
end


k = 7 # Optimal K found using the elbow method
kmeans = KMeansClusterer.run k, data, labels: labels, runs: 100
kmeans.clusters.each do |cluster|
  puts "Cluster #{cluster.id}"
  puts "Center of Cluster: #{cluster.centroid}"
  puts "Cities in Cluster: " + cluster.points.map{ |c| c.label }.join(",")
end

kmeans.clusters.each do |cluster|
  cluster.points.each do |p|
    puts "#{p.label},#{cluster.id},#{p.data[0]},#{p.data[1]}"
  end
end
