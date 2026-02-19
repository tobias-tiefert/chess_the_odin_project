# frozen_string_literal: true

require_relative 'piece'

# class that enables the pawn to strike en passant
class DummyPawn < Piece
  WHITE_TOKEN = ' '
  BLACK_TOKEN = ' '
end
# Wie stelle ich sicher, dass nur ein Pawn ihn schlagen kann?
# eigene farben? dummy_white, dummy_black