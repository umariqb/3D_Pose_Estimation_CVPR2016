#ifndef FASHION_SKIN_COLOR_MODEL_H__
#define FASHION_SKIN_COLOR_MODEL_H__

namespace fashion
{
    class SkinColorModel
    {
        public:
            virtual bool isSkin(int color[3]) const = 0;
            virtual float skinProb(int color[3]) const = 0;

            virtual ~SkinColorModel(){};
    };
}

#endif /* FASHION_SKIN_COLOR_MODEL_H__ */
