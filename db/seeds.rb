# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# db/seeds.rb

# --- MAIN CATEGORIES ---
meals = Category.find_or_create_by!(name: "Meals")
small_chops = Category.find_or_create_by!(name: "Small Chops & Sides")
drinks = Category.find_or_create_by!(name: "Drinks")
desserts = Category.find_or_create_by!(name: "Desserts")

# --- SUBCATEGORIES ---
# Meals
["Rice Dishes", "Swallows & Soups", "Pasta & Noodles", "Proteins", "Specials"].each do |sub|
  Category.find_or_create_by!(name: sub, parent: meals)
end

# Small Chops & Sides
["Finger Foods", "Grills & BBQ", "Sides"].each do |sub|
  Category.find_or_create_by!(name: sub, parent: small_chops)
end

# Drinks
["Soft Drinks", "Juices", "Smoothies", "Water", "Alcoholic Drinks"].each do |sub|
  Category.find_or_create_by!(name: sub, parent: drinks)
end

# Desserts
["Cakes", "Pastries", "Ice Cream"].each do |sub|
  Category.find_or_create_by!(name: sub, parent: desserts)
end
