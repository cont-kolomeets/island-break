/*
   COPYRIGHT (c) 2013 Kolomeets Aleksandr
   All rights reserved.
   For additional information, contact:
   email: kolomeets@live.ru
 */
package nslib.matrixUtils
{
	import nslib.utils.NSMath;
	
	public class MatrixMath
	{
		
		public static function calcDotProduct(m1:Matrix, m2:Matrix):Number
		{
			if (!m1.isRowMatrix())
			{
				m1 = MatrixMath.transpose(m1);
			}
			if (!m2.isColumnMatrix())
			{
				m2 = MatrixMath.transpose(m2);
			}
			
			var m3:Matrix = MatrixMath.multiply(m1, m2);
			
			return m3.getValueAt(0, 0);
		}
		
		public static function calcVectorLength(_columnMatrix:Matrix):Number
		{
			var _result:Number = 0;
			var _sum:Number = 0;
			
			if (_columnMatrix.getNOfColumns() == 1)
			{
				for (var i:int = 0; i < _columnMatrix.getNOfRows(); i++)
					_sum += NSMath.pow(_columnMatrix.getValueAt(0, i), 2);
				
				_result = NSMath.sqrt(_sum);
			}
			
			return _result;
		}
		
		public static function calcVectorDistance(m1:Matrix, m2:Matrix):Number
		{
			if (!m1.isColumnMatrix())
			{
				m1 = transpose(m1);
			}
			if (m1.getNOfColumns() != 1)
				return -1;
			
			if (!m2.isColumnMatrix())
			{
				m2 = transpose(m2);
			}
			if (m2.getNOfColumns() != 1)
				return -1;
			
			var sum:Number = 0;
			
			if (m1.getNOfRows() == m2.getNOfRows())
			{
				for (var i:int = 0; i < m1.getNOfRows(); i++)
				{
					sum += (m2.getValueAt(0, i) - m1.getValueAt(0, i)) * (m2.getValueAt(0, i) - m1.getValueAt(0, i));
				}
				
				return NSMath.sqrt(sum);
			}
			
			return -1;
		}
		
		public static function transpose(m1:Matrix):Matrix
		{
			
			var m2:Matrix = new Matrix(m1.getNOfRows(), m1.getNOfColumns());
			
			for (var r:int = 0; r < m1.getNOfRows(); r++)
			{
				for (var c:int = 0; c < m1.getNOfColumns(); c++)
				{
					m2.setValueAt(m1.getValueAt(c, r), r, c);
				}
			}
			
			return m2;
		}
		
		public static function ifSameSize(m1:Matrix, m2:Matrix):Boolean
		{
			var _result:Boolean = false;
			
			if (m1.getNOfColumns() == m2.getNOfColumns() && m1.getNOfRows() == m2.getNOfRows())
				_result = true;
			
			return _result;
		}
		
		public static function ifCompatable(m1:Matrix, m2:Matrix):Boolean
		{
			var _result:Boolean = false;
			
			if (m1.getNOfRows() == m2.getNOfColumns() || m2.getNOfRows() == m1.getNOfColumns())
				_result = true;
			
			return _result;
		}
		
		public static function add(m1:Matrix, m2:Matrix):Matrix
		{
			
			if (ifSameSize(m1, m2))
			{
				var m3:Matrix = new Matrix(m1.getNOfColumns(), m1.getNOfRows());
				
				for (var r:int = 0; r < m1.getNOfRows(); r++)
				{
					for (var c:int = 0; c < m1.getNOfColumns(); c++)
					{
						m3.setValueAt((m1.getValueAt(c, r) + m2.getValueAt(c, r)), c, r);
					}
				}
				
				return m3;
			}
			else
			{
				new Error("Matrixes are of different sizes!");
				return null;
			}
		}
		
		public static function subtract(m1:Matrix, m2:Matrix):Matrix
		{
			
			if (ifSameSize(m1, m2))
			{
				var m3:Matrix = new Matrix(m1.getNOfColumns(), m1.getNOfRows());
				
				for (var r:int = 0; r < m1.getNOfRows(); r++)
				{
					for (var c:int = 0; c < m1.getNOfColumns(); c++)
					{
						m3.setValueAt((m1.getValueAt(c, r) - m2.getValueAt(c, r)), c, r);
					}
				}
				
				return m3;
			}
			else
			{
				new Error("Matrixes are of different sizes!");
				return null;
			}
		}
		
		public static function multiply(m1:Matrix, m2:Matrix):Matrix
		{
			var val:Number = 0;
			
			if (ifCompatable(m1, m2))
			{
				var m3:Matrix = new Matrix(m2.getNOfColumns(), m1.getNOfRows());
				
				for (var r:int = 0; r < m1.getNOfRows(); r++)
				{
					for (var c1:int = 0; c1 < m2.getNOfColumns(); c1++)
					{
						val = 0;
						for (var c:int = 0; c < m1.getNOfColumns(); c++)
						{
							val += m1.getValueAt(c, r) * m2.getValueAt(c1, c);
						}
						m3.setValueAt(val, c1, r);
					}
					
				}
				
				return m3;
			}
			else
			{
				new Error("Matrixes are not compatible!");
				return null;
			}
		}
		
		public static function multiplyByNumber(m1:Matrix, _val:Number):Matrix
		{
			for (var r:int = 0; r < m1.getNOfRows(); r++)
				for (var c:int = 0; c < m1.getNOfColumns(); c++)
				{
					m1.setValueAt(m1.getValueAt(c, r) * _val, c, r);
				}
			return m1;
		}
		
		public static function convertToIdentity(m1:Matrix):Matrix
		{
			if (m1.getNOfColumns() == m1.getNOfRows())
			{
				var m2:Matrix = new Matrix(m1.getNOfColumns(), m1.getNOfRows());
				for (var r:int = 0; r < m2.getNOfRows(); r++)
				{
					m2.setValueAt(1, r, r);
				}
				
				return m2;
			}
			else
			{
				new Error("Cannot create identity matrix!");
				return null;
			}
		
		}
		
		public static function addColumnRight(m1:Matrix, _filling:Number):Matrix
		{
			var m2:Matrix = new Matrix(m1.getNOfColumns() + 1, m1.getNOfRows());
			
			for (var c:int = 0; c < (m1.getNOfColumns() + 1); c++)
			{
				if (c < m1.getNOfColumns())
				{
					for (var r:int = 0; r < m1.getNOfRows(); r++)
					{
						m2.setValueAt(m1.getValueAt(c, r), c, r);
					}
				}
				else
				{
					for (r = 0; r < m1.getNOfRows(); r++)
					{
						m2.setValueAt(_filling, c, r);
					}
				}
				
			}
			return m2;
		}
		
		public static function addRowBottom(m1:Matrix, _filling:Number):Matrix
		{
			var m2:Matrix = new Matrix(m1.getNOfColumns(), m1.getNOfRows() + 1);
			
			for (var r:int = 0; r < (m1.getNOfRows() + 1); r++)
			{
				if (r < m1.getNOfRows())
				{
					for (var c:int = 0; c < m1.getNOfColumns(); c++)
					{
						m2.setValueAt(m1.getValueAt(c, r), c, r);
					}
				}
				else
				{
					for (c = 0; c < m1.getNOfColumns(); c++)
					{
						m2.setValueAt(_filling, c, r);
					}
				}
				
			}
			return m2;
		}
		
		public static function setRandomValues(m1:Matrix, min:Number, max:Number):Matrix
		{
			
			for (var r:int = 0; r < m1.getNOfRows(); r++)
			{
				for (var c:int = 0; c < m1.getNOfColumns(); c++)
					m1.setValueAt(NSMath.round((max - min) * NSMath.random() * 10) / 10, c, r);
			}
			
			return m1;
		}
	
	}

}