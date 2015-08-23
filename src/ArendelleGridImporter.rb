
#
# SketchUp Arendelle Grid File Importer
# Copyright 2015 Pouya Kary <k@arendelle.org>
#



UI.menu( 'File' ).add_item( 'Import Arendelle Grid' ) {

    loader = ArendelleGridLoader.new

    loader.Load( )
  
}




class ArendelleGridLoader

   
  # Clean Screen

  def Clean

    Sketchup.active_model.entities.clear!

  end
  

  
  # Asks user for opening a Grid File

  def AskForFile

    UI.openpanel( 'Import Arendelle Grid File' , "#{ Dir.home }" , "Arendelle Grid File|*.grid||" )

  end

  

  # Gets the String of the Grid File

  def LoadGridFile grid_file_path 

    unless grid_file_path.nil?

      begin

        return File.read grid_file_path

      rescue

        return nil

      end

    else

      return nil
      
    end

  end

  

  # Breaks the Grid File

  def BreakGridFile file_string

    result = Array[ ]

    rows = file_string.gsub( /\n| |\t/ , ''  ).split /;/

    rows.each do | row |

      row_result = Array[ ]

      dots = row.split /,/

      dots.each do | dot |

        row_result.push dot.to_i

      end
      
      result.push row_result

    end
    
    return result

  end



  # Arendelle Classic colors to Sketchup ones

  def GetSketchUpDotColor dot

    case dot

    when 1

      return '#FFFFFF' 

    when 2

      return '#B3B3B3'

    when 3

      return '#6D6D6D'

    when 4

      return '#313131'

    end

  end



  # Create Dots

  def DrawDot dot_color , x , y , size

    vertices = Array[ ]
            
    vertices.push [ x         , y         , 0 ]
            
    vertices.push [ x + size  , y         , 0 ]
            
    vertices.push [ x + size  , y + size  , 0 ]
            
    vertices.push [ x         , y + size  , 0 ]
      
    dot_face = Sketchup.active_model.active_entities.add_face vertices

    dot_face.material = GetSketchUpDotColor dot_color

    dot_face.pushpull size , false
    
  end



  # Ploter Grid

  def PlotGrid grid

    x = 0

    y = 0

    size = 1.cm

    grid.each do | row |

      row.each do | dot |

        unless dot == 0

          DrawDot dot , x , y , size

        end

        x += size

      end

      y += size

      x = 0
      
    end

  end
  


  # Main

  def Load

    Clean( )

    file_path = AskForFile()

    file_string = LoadGridFile file_path

    grid = BreakGridFile file_string

    PlotGrid grid

    Sketchup.set_status_text 'Arendelle Grid Imported'

  end
  
end
