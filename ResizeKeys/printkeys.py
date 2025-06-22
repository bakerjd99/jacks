# -*- coding: utf-8 -*-
#import re
import csv
import smugpyter


class PrintKeys(smugpyter.SmugPyter):

    # some Walmart, Artmill and PWP sizes merged with SmugMug sizes
    # 2x7 aspects added Feb 20, 2023
    # numerous nonstandard ratios added while building panos Oct 22, 2023
    # more ratios added to cover some darktable panoramas June 21, 2024
    # smug_default_sizes = """
# 1x3.5    2x2      2x2.5    2x3      2x4      
# 2x5      2x7      2.25x4   2.5x2.5  2.5x3.5  
# 2.5x4    3x3      3x4      3x5      3x7      
# 3x9      3x12     3x15     3x18     3.5x3.5  
# 3.5x5    4x4      4x5      4x5.3    4x6  4x7      
# 4x8      4x10     4x14     4.25x5.5 4.5x8    
# 5x5      5x6      5x6.5    5x6.7    5x7      
# 5x8      5x10     5x30     5.25x2.25  5.5x7    5.5x8    
# 5.5x8.5  5.5x14   6x3.5    6x6      6x8      6x10     
# 6x12     6x14     6x15     6x18     6x21     
# 6x24     6x30     6x36     7x10     7.5x13.5  8x3.75  8x8      
# 8x10     8x10.6   8x12     8x16     8x20     
# 8x24     8x28     8x32     8x40     8.5x11   
# 9x12     9x15     9x16     9x21     9x36     
# 10x10    10x12    10x13    10x14    10x15    
# 10x16    10x20    10x25    10x30    10x35    
# 10x40    10x60    10.5x4.5 11x14    11x16    11x17    
# 11x28    12x7     12x12    12x15    12x18    12x20    
# 12x24    12x28    12x30    12x42    12x60    
# 14x20    15x18    15x27    16x20    16x24    16x32    
# 18x24    18x32    20x20    20x24    20x28    
# 20x30    20x40    21x9     24x36    30x30
# """

    # Darktable aspect ratios blended into size keys
    # and additional intermediate sizes added see
    # J verb (moreprintsizes) June 15, 2025
    smug_default_sizes = """
1x1.414214   1x1.618034   1x2.35       1x2.39       1x3.5        1.5x2.121321 
1.5x2.427051 1.5x3.525    1.5x3.585    1.5x5.25     2x2          2x2.5        
2x2.65       2x2.828428   2x3          2x3.236068   2x3.5        2x4          
2x4.7        2x4.78       2x5          2x7          2.125x2.75   2.25x2.25    
2.25x4       2.25x5.25    2.5x2.5      2.5x3        2.5x3.25     2.5x3.35     
2.5x3.5      2.5x4        2.625x6.125  2.75x2.75    2.75x3.5     2.75x4       
2.75x4.25    2.75x7       3x3          3x3.75       3x3.975      3x4          
3x4.242642   3x4.5        3x4.854102   3x5          3x5.25       3x6          
3x7          3x7.05       3x7.17       3x7.5        3x8.125      3x9          
3x10.5       3x12         3x15         3x18         3.1875x4.125 3.25x3.25    
3.375x6      3.5x3.5      3.5x5        3.5x6        3.75x3.75    3.75x4.5     
3.75x4.875   3.75x5.025   3.75x5.25    3.75x6       3.75x6.75    3.75x8       
3.75x8.75    4x4          4x5          4x5.3        4x5.656856   4x6          
4x6.472136   4x7          4x8          4x9.4        4x9.56       4x10         
4x14         4x24         4.125x5.25   4.125x6      4.125x6.375  4.125x10.5   
4.25x5.5     4.5x4.5      4.5x6        4.5x7.5      4.5x8        4.5x9        
4.5x10.5     4.5x12.1875  4.5x13.5     4.5x18       4.5x22.5     5x5          
5x6          5x6.5        5x6.7        5x7          5x8          5x10         
5x12.5       5x17.5       5x30         5.25x7.5     5.25x9       5.25x12.25   
5.5x5.5      5.5x7        5.5x8        5.5x8.5      5.5x11       5.5x14       
5.5x33       5.625x10.125 5.625x12     6x6          6x7.5        6x7.95       
6x8          6x8.485284   6x9          6x9.708204   6x10         6x10.5       
6x12         6x14         6x14.1       6x14.34      6x15         6x16.25      
6x18         6x21         6x24         6x30         6x36         6.375x8.25   
6.75x12      7x7          7x10         7x12         7x14         7x17.5       
7x21         7x24.5       7x28         7x35         7.5x9        7.5x9.75     
7.5x10       7.5x10.05    7.5x10.5     7.5x12       7.5x12.5     7.5x13.5     
7.5x16       7.5x17.5     8x8          8x10         8x10.6       8x11.313712  
8x12         8x12.944272  8x14         8x16         8x18.8       8x19.12      
8x20         8x24         8x28         8x32         8x40         8x48         
8.25x10.5    8.25x12      8.25x12.75   8.25x21      8.5x11       8.5x34       
9x9          9x12         9x13.5       9x15         9x16         9x18         
9x21         9x22.5       9x24.375     9x27         9x31.5       9x36         
9.5x38       10x10        10x12        10x12.5      10x13        10x13.4      
10x14        10x15        10x16        10x20        10x25        10x30        
10x35        10x40        10x50        10x60        10.5x14      10.5x15      
10.5x17.5    10.5x18      10.5x24.5    11x11        11x14        11x16        
11x16.5      11x17        11x22        11x27.5      11x28        11x33        
11x38.5      11x44        11x66        11.25x20.25  11.25x24     12x12        
12x15        12x15.9      12x16        12x16.970568 12x18        12x19.416408 
12x20        12x21        12x24        12x28        12x28.2      12x28.68     
12x30        12x32.5      12x36        12x42        12x48        12x60        
12x72        12.5x15      12.75x16.5   13.5x24      14x14        14x17.5      
14x20        14x21        14x24        14x28        14x35        14x49        
15x18        15x19.5      15x20        15x20.1      15x21        15x24        
15x27        15x32        15x35        16x16        16x20        16x21.2      
16x22.627424 16x24        16x25.888544 16x28        16x32        16x37.6      
16x38.24     16x40        16x56        16.5x21      16.5x24      16.5x25.5    
16.5x42      17x22        17.5x21      18x18        18x24        18x27        
18x30        18x32        18x36        18x42        18x48.75     18x54        
18x72        18x90        18x108       20x20        20x24        20x26        
20x26.8      20x28        20x30        20x32        20x40        21x28        
21x30        21x36        22x28        22x32        22x33        22x34        
22x56        22.5x40.5    22.5x48      24x32        24x36        24x40        
24x65        24x72        24x96        24x120       24x144       25x25        
28x40        28x48        30x30        30x54        30x64  
"""

    # print size key lists
    aspect_ratios = None
    print_areas = None
    size_keywords = None

    def __init__(self, *, verbose=False, yammer=False, log_start=False):
        """ class constructor """
        super().__init__(log_start=log_start, yammer=yammer, verbose=verbose)
        self.smug_print_sizes = self.purify_smugmug_text(
            self.smug_default_sizes).split()
        (self.aspect_ratios, self.print_areas,
         self.size_keywords) = self.set_print_sizes(self.smug_print_sizes)

    # precision should match J smugpyter SMUGASPECTROUND=. 0.005
    def aspect_ratio(self, height, width, *, precision=0.005):
        """ Image aspect ratio """
        return self.round_to(min(height, width) / max(height, width), precision)

    # precision should match J smugpyter SMUGAREAROUND=. 0.05
    def dpi_area(self, height, width, *, dpi=360, precision=0.05):
        """ Area required for given DPI/PPI """
        return self.round_to((height * width) / dpi ** 2, precision)

    def set_print_sizes(self, smug_print_sizes):
        """
        Sets the lists that represent the print sizes table.
        Result is a tuple of lists (aspect_ratios, print_areas, size_keywords).
        """
        all_aspect_ratios = []
        all_print_areas = []
        for size in smug_print_sizes:
            height, width = size.split('x')
            height = float(height)
            width = float(width)
            ratio = self.aspect_ratio(height, width)
            area = height * width
            all_aspect_ratios.append(ratio)
            all_print_areas.append(area)
        aspect_ratios = list(set(all_aspect_ratios))

        allcnt = len(smug_print_sizes)
        if (allcnt != len(all_aspect_ratios) or allcnt != len(all_print_areas)):
            raise ValueError('ratio list lengths invalid')

        # group areas and keys by ratios
        print_areas = []
        size_keywords = []
        for ur in aspect_ratios:
            gp = []
            gk = []
            for ar, pa, sk in zip(all_aspect_ratios, all_print_areas, smug_print_sizes):
                if ur == ar:
                    gp.append(pa)
                    gk.append(sk)
            # insure sublists are sorted by ascending area
            gp, gk = self.dualsort(gp, gk)
            print_areas.append(gp)
            size_keywords.append(gk)

        return (aspect_ratios, print_areas, size_keywords)

    def print_size_key(self, height, width, *, no_ratio='0z1', no_pixels='0z0',
                       min_area=1.0, ppi=360, tolerance=0.000005):
        """
        Compute print size key word from image dimensions. 
        The result is a character string.

          key360 = print_size_key(2000, 3000)

          # (ppi) is identical to dpi here
          key720 = print_size_key(2000, 3000, ppi=720) 
        """
        # basic argument check
        error_message = '(height), (width) must be positive integers'
        if not (isinstance(height, int) and isinstance(width, int)):
            raise TypeError(error_message)
        elif height <= 0 or width <= 0:
            raise ValueError(error_message)

        # area must exceed a minimum size
        print_area = self.dpi_area(height, width, dpi=ppi)
        if print_area < min_area:
            return no_pixels

        print_ratio = self.aspect_ratio(height, width)
        print_key = no_ratio
        for i, ratio in enumerate(self.aspect_ratios):
            if abs(print_ratio - ratio) <= tolerance:
                print_key = no_pixels

                # not enough or more than enough area
                if print_area < self.print_areas[i][0]:
                    break
                elif print_area > self.print_areas[i][-1]:
                    print_key = self.size_keywords[i][-1]
                    break

                for j, area in enumerate(self.print_areas[i]):
                    if area >= print_area and 0 < j:
                        print_key = self.size_keywords[i][j - 1]
                        break

        return print_key

    def print_keywords(self, manifest_file, *, split_delimiter=';'):
        """
        Set print size keywords for images in album manifest file.
        Result is a tuple (image_count, change_count, changed_keywords).
        (changed_keyords) is a list of dictionaries in (csv.DictWriter) format.
        """
        changes_dict = {}
        if self.merge_changes:
            changes_file = self.changes_filename(manifest_file)
            changes_dict = self.image_dict_from_csv(changes_file)
            changes_dict = self.merge_keywords_from_csv(self.all_geotag_changes_file, changes_dict)
        merge_keys = self.merge_changes and 0 < len(changes_dict)

        changed_keywords = []
        image_count, change_count = 0, 0
        with open(manifest_file, 'r') as f:
            reader = csv.DictReader(f, dialect='excel', delimiter='\t')
            for row in reader:
                image_count += 1
                key = row['ImageKey']
                inwords = row['Keywords']

                # merge in current changes file keywords
                if merge_keys:
                    if key in changes_dict:
                        inwords = inwords + split_delimiter + \
                            changes_dict[key]['Keywords']

                height, width = int(row['OriginalHeight']), int(
                    row['OriginalWidth'])
                size_key = self.print_size_key(height, width)
                same, new_keywords = self.update_keywords(size_key, inwords)
                if not same:
                    change_count += 1
                    if self.verbose == True:
                        print(row['FileName'] + ' | ' + new_keywords)
                    key_change = {'ImageKey': key, 'AlbumKey': row['AlbumKey'],
                                   'FileName': row['FileName'], 'Keywords': new_keywords}
                    changed_keywords.append(key_change)
                    self.all_keyword_changes[key] = key_change

        # when no images are changed return a header place holder row
        if change_count == 0:
            changed_keywords.append({'ImageKey': None, 'AlbumKey': None, 'FileName': None,
                                     'Keywords': None})

        return (image_count, change_count, changed_keywords)

    def write_size_keyword_changes(self, manifest_file):
        """
        Write TAB delimited file of changed print size keywords.
        Return album and keyword (image_count, change_count) tuple.

            manifest_file = r'c:\SmugMirror\Places\Overseas\Ghana1970s\manifest-Ghana1970s-Kng6tg-w.txt'
            write_size_keyword_changes(manifest_file)  
        """
        return self.write_keyword_changes(manifest_file, func_keywords=self.print_keywords)

    def update_all_size_keyword_changes(self, root):
        """
        Scan all manifest files in local directories and
        generate TAB delimited CSV print size keyword changes files.

            pk = PrintKeys()
            pk.update_all_size_keyword_changes(r'c:\SmugMirror')
        """
        print("processing print size leys")
        self.all_keyword_changes = {}
        imc = self.scan_do_local_files(root, func_do=self.write_size_keyword_changes)
        self.write_all_keyword_changes(self.all_sizetag_changes_file)
        return imc


# if __name__ == '__main__':
    # pk = PrintKeys()
