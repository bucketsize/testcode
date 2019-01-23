clean :
	-rm *.o *.hi *.exe
	-find . -type f -executable -delete

%: %.hs
	ghc $^
