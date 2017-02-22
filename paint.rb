#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

# A class that will handle the painting
class Painter
  # The borders of any given cell
  BORDERCELLS = [
    [0, 1],
    [1, 0],
    [1, 1],
    [-1, 0],
    [0, -1],
    [1, -1],
    [-1, 1],
    [-1, -1]
  ]

  ##
  ## The class constructor
  def initialize
    image_dimensions_from_user_inputs
    populate_new_image
    coordinates_of_the_filling_cell

    puts 'Enter the replaceing color you want: '
    @replace_color = gets.to_i
    @old_color = @image[@x][@y]

    # To mark all visited cells
    @visited_cells = []

    # Stack of adjacent cells which will be filled
    @adjacent_cells = [[@x, @y]]
  end

  ##
  # Fills the given cell as well as all adjacent ones
  #
  # An ArgumentError is raised if the given position
  # coordinates are out of image boundry.
  def fill_cells
    if @x < 0 || @y < 0 || @x >= @image.length || @y >= @image[@x].length
      fail ArgumentError, 'Out of boundry coordinates'
    end

    replace_color

    puts 'Filled image array: '
    pretty_print_2d_array(@image)
  end

  private

  ##
  # Replaces_the color of the celected cell
  def replace_color #:doc:
    until @adjacent_cells.empty?
      cell = @adjacent_cells.pop
      @image[cell[0]][cell[1]] = @replace_color
      @visited_cells.push(cell)

      # Add cells to the fill stack
      BORDERCELLS.each do |border_cell|
        @next_cell = [cell[0] + border_cell[0], cell[1] + border_cell[1]]
        next if check_cell_for_filling
        @adjacent_cells.push(@next_cell)
      end
    end
  end

  ##
  # Pre-checks the cell before filling
  def check_cell_for_filling #:doc:
    return true if @next_cell[0] < 0 || @next_cell[0] >= @image.length
    return true if @next_cell[1] < 0 || @next_cell[1] >= @image[@next_cell[0]].length
    return true if @image[@next_cell[0]][@next_cell[1]] != @old_color
    return true if @visited_cells.include?(@next_cell)
  end

  ##
  # Gets width and height from user inputs
  def image_dimensions_from_user_inputs #:doc:
    puts 'Please enter the image dimensions'
    puts 'Image width: '
    @width = gets.to_i
    puts 'Image height: '
    @height = gets.to_i
    @image = Array.new(@height) { Array.new(@width) }
  end

  ##
  # Populates the image array from user input
  def populate_new_image #:doc:
    puts 'Populate your image 2D array: '

    (0...@width).each do |row|
      (0...@height).each do |cell|
        puts "At row: #{row}, cell: #{cell}: "
        @image[row][cell] = gets.to_i
      end
    end

    puts '======================'
    puts 'Unfilled image array: '
    pretty_print_2d_array(@image)
  end

  ##
  # Gets x, and y coordinates of the cell that will be filled
  def coordinates_of_the_filling_cell #:doc:
    puts 'Enter the position x of the cell: '
    @x = gets.to_i
    puts 'Enter the position y of the cell: '
    @y = gets.to_i
  end

  ##
  # Prety prints a 2D array in rows and columns format
  # for example:
  #
  # 9 8 3
  # 4 9 3
  # 2 5 9
  def pretty_print_2d_array(array) #:doc:
    array.each do |row|
      puts row.each { |p| p }.join(' ')
    end
  end
end

painter = Painter.new
painter.fill_cells
