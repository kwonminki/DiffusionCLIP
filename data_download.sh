
DATASET=$1
BASE_DIR=$2

if [ $DATASET == "celeba_hq" ] || [ $DATASET == "afhq" ]; then
  if [ $DATASET == "celeba_hq" ]; then
      URL_ID="1R72NB79CX0MpnmWSli2SMu-Wp-M0xI-o"
      DATASET_FOLDER=$BASE_DIR/data/celeba_hq
      ZIP_FILE=$DATASET_FOLDER/celeba_hq_raw.zip
  elif  [ $DATASET == "afhq" ]; then
      URL_ID="1Pf4f6Y27lQX9y9vjeSQnoOQntw_ln7il"
      DATASET_FOLDER=$BASE_DIR/data/afhq
      ZIP_FILE=$DATASET_FOLDER/afhq_raw.zip
  else
    echo "Unknown DATASET"
    exit 1
  fi

  echo "lalala"
  mkdir -p $DATASET_FOLDER

  wget --load-cookies ~/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies ~/cookies.txt --keep-session-cookies --no-check-certificate "https://docs.google.com/uc?export=download&id=${URL_ID}" -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=${URL_ID}" -O $ZIP_FILE && rm -rf ~/cookies.txt
  unzip $ZIP_FILE -d $DATASET_FOLDER
  rm $ZIP_FILE

  # raw images to LMDB format
  TARGET_SIZE=256,1024
  for DATASET_TYPE in "train" "test" "val"; do
      python utils/prepare_lmdb_data.py --out $DATASET_FOLDER/LMDB_$DATASET_TYPE --size $TARGET_SIZE $DATASET_FOLDER/raw_images/$DATASET_TYPE
  done

else
    echo "Unknown DATASET"
    exit 1
fi
