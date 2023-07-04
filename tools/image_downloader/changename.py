import os
import glob

# your list of objects
'''
objects = [
    ("人物", "媽媽", "mom"),
    ("人物", "爸爸", "dad")
]
'''
objects = [
    ("人物", "媽媽", "mom"),
    ("人物", "爸爸", "dad"),
    ("人物", "哥哥", "elder brother"),
    ("人物", "姐姐", "elder sister"),
    ("人物", "弟弟", "younger brother"),
    ("人物", "妹妹", "younger sister"),
    ("人物", "爺爺", "grandfather"),
    ("人物", "奶奶", "grandmother"),
    ("人物", "阿公", "grandpa"),
    ("人物", "阿嬤", "grandma"),
    ("人物", "叔叔", "uncle"),
    ("人物", "阿姨", "aunt"),
    ("人物", "老師", "teacher"),
    ("人物", "同學", "classmate"),
    ("人物", "男生", "boy"),
    ("人物", "女生", "girl"),
    ("人物", "大人", "adult"),
    ("人物", "小孩", "child"),
    ("食物", "豆漿", "soy milk"),
    ("食物", "牛奶", "milk"),
    ("食物", "燒餅", "sesame flatbread"),
    ("食物", "飯糰", "rice ball"),
    ("食物", "吐司", "toast"),
    ("食物", "麵包", "bread"),
    ("食物", "稀飯", "porridge"),
    ("食物", "地瓜葉", "sweet potato leaves"),
    ("食物", "高麗菜", "cabbage"),
    ("食物", "花椰菜", "cauliflower"),
    ("食物", "蛋炒飯", "fried rice"),
    ("食物", "番茄炒蛋", "scrambled eggs with tomatoes"),
    ("食物", "雞排", "chicken steak"),
    ("食物", "漢堡", "hamburger"),
    ("食物", "玉米湯", "corn soup"),
    ("食物", "水餃", "dumplings"),
    ("食物", "牛肉麵", "beef noodles"),
    ("動物", "小狗", "puppy"),
    ("動物", "小貓", "kitten"),
    ("動物", "鳥", "bird"),
    ("動物", "蜻蜓", "dragonfly"),
    ("動物", "蝴蝶", "butterfly"),
    ("動物", "魚", "fish"),
    ("動物", "烏龜", "turtle"),
    ("動物", "兔子", "rabbit"),
    ("動物", "蝸牛", "snail"),
    ("動物", "螞蟻", "ant"),
    ("動物", "小豬", "piglet"),
    ("動物", "小鹿", "fawn"),
    ("動物", "小羊", "lamb"),
    ("動物", "老虎", "tiger"),
    ("動物", "孔雀", "peacock"),
    ("植物", "榕樹", "Banyan tree"),
    ("植物", "櫻花樹", "Cherry blossom tree"),
    ("植物", "草地", "Grassland"),
    ("植物", "欒樹", "Goldenrain tree"),
    ("植物", "紫藤", "Wisteria"),
    ("植物", "草莓", "Strawberry"),
    ("植物", "向日葵", "Sunflower"),
    ("植物", "玫瑰", "Rose"),
    ("植物", "蘋果樹", "Apple tree"),
    ("植物", "綠竹", "Green bamboo"),
    ("植物", "芒果樹", "Mango tree"),
    ("植物", "紅檜樹", "Red cypress tree"),
    ("植物", "柳杉樹", "Cryptomeria tree"),
    ("植物", "樟樹", "Camphor tree"),
    ("植物", "五葉松", "Five-leaf pine"),
    ("植物", "玉山杉", "Taiwan cypress"),
    ("植物", "桂竹筍", "Bamboo shoot"),
    ("植物", "枇杷樹", "Loquat tree"),
    ("植物", "杉木樹", "Fir tree"),
    ("植物", "椰子樹", "Coconut tree"),
    ("植物", "杜鵑花", "Rhododendron"),
    ("植物", "菊花", "Chrysanthemum"),
    ("植物", "玫瑰花", "Rose flower")
]

for object in objects:
    dir_name, new_name, old_name = object
    # print('dir_name =', dir_name, 'new_name =', new_name, 'old_name =', old_name)

    # get list of all png files in the directory
    files = glob.glob(f'./{dir_name}/*.png')
    for file in files:
        # check if the old name is in the file name
        if old_name in file:
            # generate new file name and rename the file
            new_file = file.replace(old_name, new_name)
            # print(f"Renaming {file} to {new_file}")
            os.rename(file, new_file)


'''

objects = [
    ("人物", "媽媽", "mom"),
    ("人物", "爸爸", "dad"),
    ("人物", "哥哥", "elder brother"),
    ("人物", "姐姐", "elder sister"),
    ("人物", "弟弟", "younger brother"),
    ("人物", "妹妹", "younger sister"),
    ("人物", "爺爺", "grandfather"),
    ("人物", "奶奶", "grandmother"),
    ("人物", "阿公", "grandpa"),
    ("人物", "阿嬤", "grandma"),
    ("人物", "叔叔", "uncle"),
    ("人物", "阿姨", "aunt"),
    ("人物", "老師", "teacher"),
    ("人物", "同學", "classmate"),
    ("人物", "男生", "boy"),
    ("人物", "女生", "girl"),
    ("人物", "大人", "adult"),
    ("人物", "小孩", "child"),
    ("食物", "豆漿", "soy milk"),
    ("食物", "牛奶", "milk"),
    ("食物", "燒餅", "sesame flatbread"),
    ("食物", "飯糰", "rice ball"),
    ("食物", "吐司", "toast"),
    ("食物", "麵包", "bread"),
    ("食物", "稀飯", "porridge"),
    ("食物", "地瓜葉", "sweet potato leaves"),
    ("食物", "高麗菜", "cabbage"),
    ("食物", "花椰菜", "cauliflower"),
    ("食物", "蛋炒飯", "fried rice"),
    ("食物", "番茄炒蛋", "scrambled eggs with tomatoes"),
    ("食物", "雞排", "chicken steak"),
    ("食物", "漢堡", "hamburger"),
    ("食物", "玉米湯", "corn soup"),
    ("食物", "水餃", "dumplings"),
    ("食物", "牛肉麵", "beef noodles"),
    ("動物", "小狗", "puppy"),
    ("動物", "小貓", "kitten"),
    ("動物", "鳥", "bird"),
    ("動物", "蜻蜓", "dragonfly"),
    ("動物", "蝴蝶", "butterfly"),
    ("動物", "魚", "fish"),
    ("動物", "烏龜", "turtle"),
    ("動物", "兔子", "rabbit"),
    ("動物", "蝸牛", "snail"),
    ("動物", "螞蟻", "ant"),
    ("動物", "小豬", "piglet"),
    ("動物", "小鹿", "fawn"),
    ("動物", "小羊", "lamb"),
    ("動物", "老虎", "tiger"),
    ("動物", "孔雀", "peacock"),
    ("植物", "榕樹", "Banyan tree"),
    ("植物", "櫻花樹", "Cherry blossom tree"),
    ("植物", "草地", "Grassland"),
    ("植物", "欒樹", "Goldenrain tree"),
    ("植物", "紫藤", "Wisteria"),
    ("植物", "草莓", "Strawberry"),
    ("植物", "向日葵", "Sunflower"),
    ("植物", "玫瑰", "Rose"),
    ("植物", "蘋果樹", "Apple tree"),
    ("植物", "綠竹", "Green bamboo"),
    ("植物", "芒果樹", "Mango tree"),
    ("植物", "紅檜樹", "Red cypress tree"),
    ("植物", "柳杉樹", "Cryptomeria tree"),
    ("植物", "樟樹", "Camphor tree"),
    ("植物", "五葉松", "Five-leaf pine"),
    ("植物", "玉山杉", "Taiwan cypress"),
    ("植物", "桂竹筍", "Bamboo shoot"),
    ("植物", "枇杷樹", "Loquat tree"),
    ("植物", "杉木樹", "Fir tree"),
    ("植物", "椰子樹", "Coconut tree"),
    ("植物", "杜鵑花", "Rhododendron"),
    ("植物", "菊花", "Chrysanthemum"),
    ("植物", "玫瑰花", "Rose flower")
]

'''