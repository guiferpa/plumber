read_index() {
  # build test data
  # ===============
  prefix="௵"   # prefix all non-zero length strings will this obvious 3-byte marker.
  prefix="0"
  prelen=$(echo -n $prefix|wc -c)
  printf \\0 > binfile  # force 1st string to be zero-length (to check zero-length logic) 
  ( lmax=3 # line max ... the last on is set to  255-length (to check  max-length logic)
    for ((i=1;i<=$lmax;i++)) ; do    # add prefixed random length lines 
      suflen=$(random /0..$((255-prelen))/)  # random length string (min of 3 bytes)
      ((i==lmax)) && ((suflen=255-prelen))      # make last line full length (255) 
      strlen=$((prelen+suflen))
      printf \\$((($strlen/64)*100+$strlen%64/8*10+$strlen%8))"$prefix"
      for ((j=0;j<suflen;j++)) ; do
        byteval=$(random /9,10,32..126/)  # output only printabls ASCII characters
        printf \\$((($byteval/64)*100+$byteval%64/8*10+$byteval%8))
      done
        # 'numrandom' is from package 'num-utils"
    done
  ) >>binfile

  okfn
}


