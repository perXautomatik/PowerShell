< #  
 = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  
   R E B O O T   R E M O T E   C O M P U T E R   -   A L T   C R E D E N T I A L S  
 = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  
   C r e a t e d :   [ 1 2 / 0 7 / 2 0 1 1 ]  
   A u t h o r :   E t h a n   B e l l  
   A r g u m e n t s :  
 = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  
   M o d i f i e d :   7 / 2 4 / 2 0 1 4  
   M o d i f i c a t i o n s :   T h r e e   m a j o r   m o d i f i c a t i o n s   w e r e   m a d e   t o   t h e   s c r i p t .  
       1 .   P r o m p t   f o r   c r e d e n t i a l s  
       2 .   L i s t   a n d   p r o m p t   f o r   a c t i o n ,   s c r i p t   w a s   o r i g i n a l l y   h a r d - c o d e d   f o r   a c t i o n  
       3 .   P r o m p t   f o r   m a c h i n e   n a m e  
  
  
 = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  
   P u r p o s e :   T o   r e b o o t   a   r e m o t e   c o m p u t e r   u s i n g   d i f f e r e n t   c r e d e n t i a l s  
   O p t i o n s :   0   -   L o g o f f  
                     4   -   F o r c e d   L o g   O f f  
                     1   -   S h u t d o w n  
                     5   -   F o r c e d   S h u t d o w n  
                     3   -   R e b o o t  
                     6   -   F o r c e d   R e b o o t  
                     8   -   P o w e r   O f f  
                   1 2   -   F o r c e d   P o w e r   O f f  
 = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =  
 # >  
  
 W r i t e - H o s t   " O p t i o n s : "  
 W r i t e - H o s t   "     0   -   L o g o f f "  
 W r i t e - H o s t   "     1   -   S h u t d o w n "  
 W r i t e - H o s t   "     3   -   R e b o o t "  
 W r i t e - H o s t   "     4   -   F o r c e d   L o g   O f f "  
 W r i t e - H o s t   "     5   -   F o r c e d   S h u t d o w n "  
 W r i t e - H o s t   "     6   -   F o r c e d   R e b o o t "  
 W r i t e - H o s t   "     8   -   P o w e r   O f f "  
 W r i t e - H o s t   "   1 2   -   F o r c e d   P o w e r   O f f "  
 W r i t e - H o s t   " "  
  
 # *   P r o m p t   u s e r   f o r   o p t i o n   -   s e e   l i s t   a b o v e .  
 $ v R e m o t e B o o t O p t i o n   =   R e a d - H o s t   ' W h a t   o p t i o n   w o u l d   y o u   l i k e   t o   p e r f o r m ? '  
  
 # *   P r o m p t   u s e r   f o r   t h e   c o m p u t e r   n a m e .  
 $ v C o m p u t e r N a m e   =   R e a d - H o s t   ' W h a t   i s   t h e   c o m p u t e r   n a m e ? '  
  
 ( g w m i   w i n 3 2 _ O p e r a t i n g S y s t e m   - C o m p u t e r N a m e   $ v C o m p u t e r N a m e   - c r e d   ( g e t - c r e d e n t i a l ) ) . W i n 3 2 S h u t d o w n ( $ v R e m o t e B o o t O p t i o n )
