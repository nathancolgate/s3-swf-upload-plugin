module S3SwfUpload
  module Signature
    $hexcase = false  # hex output format. false - lowercase; true - uppercase
    $b64pad  = "=" # base-64 pad character. "=" for strict RFC compliance
    $chrsz   = 8  # bits per input character. 8 - ASCII; 16 - Unicode    

    def hex_sha1(s)
      return binb2hex(core_sha1(str2binb(s), s.length * $chrsz))
    end

    def b64_hmac_sha1(key, data)
      return binb2b64(core_hmac_sha1(key, data))
    end

    # Absolute barebones "unit" tests
    def assert(expr)
      raise 'Assertion failed' unless (expr)
    end

    def self_test
      num, cnt = [1732584193, 5]

      assert(core_sha1(str2binb('abc'), 'abc'.length) == [-519653305, -1566383753, -2070791546, -753729183, -204968198])
      assert(rol(num, cnt) == -391880660)
      assert(safe_add(2042729798, num) == -519653305)
      assert((num.js_shl(cnt)) == -391880672)
      assert((num.js_shr_zf(32 - cnt)) == 12)
      assert(sha1_ft(0, -271733879, -1732584194, 271733878) == -1732584194)
      assert(sha1_kt(0) == 1518500249)
      assert(safe_add(safe_add(rol(num, cnt), sha1_ft(0, -271733879, -1732584194, 271733878)), safe_add(safe_add(-1009589776, 1902273280), sha1_kt(0))) == 286718899)
      assert(str2binb('foo bar hey there') == [1718578976, 1650553376, 1751480608, 1952998770, 1694498816])
      assert(hex_sha1("abc") == "a9993e364706816aba3e25717850c26c9cd0d89d")
      assert(b64_hmac_sha1("foo", "abc") == "frFXMR9cNoJdsSPnjebZpBhUKzI=")
    end

    # Calculate the SHA-1 of an array of big-endian words, and a bit length
    def core_sha1(x, len)
      # append padding
      x[len >> 5] ||= 0
      x[len >> 5] |= 0x80 << (24 - len % 32)
      x[((len + 64 >> 9) << 4) + 15] = len

      w = Array.new(80, 0)
      a =  1732584193
      b = -271733879
      c = -1732584194
      d =  271733878
      e = -1009589776

      #for(var i = 0; i < x.length; i += 16)
      i = 0
      while(i < x.length)
        olda = a
        oldb = b
        oldc = c
        oldd = d
        olde = e

        #for(var j = 0; j < 80; j++)
        j = 0
        while(j < 80)
          if(j < 16) 
            w[j] = x[i + j] || 0
          else 
            w[j] = rol(w[j-3] ^ w[j-8] ^ w[j-14] ^ w[j-16], 1)
          end

          t = safe_add(safe_add(rol(a, 5), sha1_ft(j, b, c, d)),
                       safe_add(safe_add(e, w[j]), sha1_kt(j)))
          e = d
          d = c
          c = rol(b, 30)
          b = a
          a = t
          j += 1
        end

        a = safe_add(a, olda)
        b = safe_add(b, oldb)
        c = safe_add(c, oldc)
        d = safe_add(d, oldd)
        e = safe_add(e, olde)
        i += 16
      end
      return [a, b, c, d, e]
    end

    # Perform the appropriate triplet combination function for the current
    # iteration
    def sha1_ft(t, b, c, d)
      return (b & c) | ((~b) & d) if(t < 20) 
      return b ^ c ^ d if(t < 40)
      return (b & c) | (b & d) | (c & d) if(t < 60)
      return b ^ c ^ d;
    end

    # Determine the appropriate additive constant for the current iteration
    def sha1_kt(t)
      return (t < 20) ?  1518500249 : (t < 40) ?  1859775393 :
             (t < 60) ? -1894007588 : -899497514
    end

    # Calculate the HMAC-SHA1 of a key and some data
    def core_hmac_sha1(key, data)
      bkey = str2binb(key)
      if(bkey.length > 16) 
        bkey = core_sha1(bkey, key.length * $chrsz)
      end

      ipad = Array.new(16, 0)
      opad = Array.new(16, 0)
      #for(var i = 0; i < 16; i++)
      i = 0
      while(i < 16)
        ipad[i] = (bkey[i] || 0) ^ 0x36363636
        opad[i] = (bkey[i] || 0) ^ 0x5C5C5C5C
        i += 1
      end

      hash = core_sha1((ipad + str2binb(data)), 512 + data.length * $chrsz)
      return core_sha1((opad + hash), 512 + 160)
    end

    # Add integers, wrapping at 2^32. This uses 16-bit operations internally
    # to work around bugs in some JS interpreters.
    def safe_add(x, y)
      v = (x+y) % (2**32)
      return v > 2**31 ? v- 2**32 : v
    end

    # Bitwise rotate a 32-bit number to the left.
    def rol(num, cnt)
      #return (num << cnt) | (num >>> (32 - cnt))
      return (num.js_shl(cnt)) | (num.js_shr_zf(32 - cnt))
    end

    # Convert an 8-bit or 16-bit string to an array of big-endian words
    # In 8-bit function, characters >255 have their hi-byte silently ignored.
    def str2binb(str)
      bin = []
      mask = (1 << $chrsz) - 1
      #for(var i = 0; i < str.length * $chrsz; i += $chrsz)
      i = 0
      while(i < str.length * $chrsz)
        bin[i>>5] ||= 0
        bin[i>>5] |= (str[i / $chrsz].ord & mask) << (32 - $chrsz - i%32)
        i += $chrsz
      end
      return bin
    end

    # Convert an array of big-endian words to a string
    #   function binb2str(bin)
    # {
    #   var str = "";
    #   var mask = (1 << $chrsz) - 1;
    #   for(var i = 0; i < bin.length * 32; i += $chrsz)
    #     str += String.fromCharCode((bin[i>>5] >>> (32 - $chrsz - i%32)) & mask);
    #   return str;
    # }
    # 

    # Convert an array of big-endian words to a hex string.
    def binb2hex(binarray)
      hex_tab = $hexcase ? "0123456789ABCDEF" : "0123456789abcdef"
      str = ""
      #for(var i = 0; i < binarray.length * 4; i++)
      i = 0
      while(i < binarray.length * 4)
        str += hex_tab[(binarray[i>>2] >> ((3 - i%4)*8+4)) & 0xF].chr +
               hex_tab[(binarray[i>>2] >> ((3 - i%4)*8  )) & 0xF].chr
        i += 1
      end
      return str;
    end

    # Convert an array of big-endian words to a base-64 string
    def binb2b64(binarray)
      tab = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
      str = ""

      #for(var i = 0; i < binarray.length * 4; i += 3)
      i = 0
      while(i < binarray.length * 4)
        triplet = (((binarray[i   >> 2].to_i >> 8 * (3 -  i   %4)) & 0xFF) << 16) |
                     (((binarray[i+1 >> 2].to_i >> 8 * (3 - (i+1)%4)) & 0xFF) << 8 ) |
                      ((binarray[i+2 >> 2].to_i >> 8 * (3 - (i+2)%4)) & 0xFF)
        #for(var j = 0; j < 4; j++)
        j = 0
        while(j < 4)
          if(i * 8 + j * 6 > binarray.length * 32)
            str += $b64pad
          else
            str += tab[(triplet >> 6*(3-j)) & 0x3F].chr
          end
          j += 1
        end
        i += 3
      end
      return str
    end
  end
end
