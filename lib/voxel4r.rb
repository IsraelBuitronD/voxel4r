require "voxel4r/version"

require 'rasem'
require 'yaml'

module Voxel4r

  class VoxelGraph
    def initialize(data, unitary_length, theta)
      @edge_length = unitary_length
      @data = data
      @theta = theta

      compute_dimensions!
    end

    def drawVoxelGraph
      lines = []

      # Join vertices
      @data.each do |v|
        flb = compute_2d_flb_point(v)
        voxel_edges = compute_voxel_edges(flb[0],flb[1])
        voxel_edges.each { |l| lines << l }
      end

      # Draw lines in SVG image
      img = Rasem::SVGImage.new(@width, @height) do
        lines.each { |l| line l[0], l[1], l[2], l[3] }
      end

      img
    end

    private

    def compute_voxel_edges(flb_x,flb_y)
      # Voxel vertices offsets
      x1, x2, x3 = @alpha_x, @edge_length, @gamma_x
      y1, y2, y3 = @alpha_y, @edge_length, @gamma_y

      m = [[ 0,x2,x2, 0, 0,x2,x2, 0,x1,x3,x3,x1],
           [ 0, 0,y2,y2, 0, 0,y2,y2,y1,y1,y3,y3],
           [x2,x2, 0, 0,x1,x3,x3,x1,x3,x3,x1,x1],
           [ 0,y2,y2, 0,y1,y1,y3,y3,y1,y3,y3,y1]]
      m[0].map! {|x| flb_x + x }
      m[1].map! {|y| flb_y - y }
      m[2].map! {|x| flb_x + x }
      m[3].map! {|y| flb_y - y }
      m = m.transpose
    end

    def compute_2d_flb_point(voxel_index)
      x = voxel_index[0]
      y = voxel_index[1]
      z = voxel_index[2]

      flb_x = @edge_length * (x + (z * Math.cos(@theta)))
      flb_y = @edge_length * ((@max_y+1-y) + ((@max_z+1-z) * Math.sin(@theta)))

      [flb_x,flb_y]
    end

    def compute_dimensions!
      @max_x, @max_y, @max_z = 0,0,0

      # Set maximums and minimums voxels
      @data.each do |v|
        @max_x = v[0] if v[0] > @max_x
        @max_y = v[1] if v[1] > @max_y
        @max_z = v[2] if v[2] > @max_z
      end

      # Compute helper lengths
      @alpha_x = @edge_length * Math.cos(@theta)
      @gamma_x = @alpha_x + @edge_length
      @alpha_y = @edge_length * Math.sin(@theta)
      @gamma_y = @alpha_y + @edge_length

      # Compute SVG image dimensions
      @width  = (@edge_length * ((@max_x+1) + (@max_z+1) * Math.cos(@theta))).ceil
      @height = (@edge_length * ((@max_y+1) + (@max_z+1) * Math.sin(@theta))).ceil
    end

  end

end
