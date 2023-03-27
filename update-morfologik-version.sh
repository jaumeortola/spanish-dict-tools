dictVers=2.0
unzip ~/.m2/repository/org/softcatala/spanish-pos-dict/${dictVers}/spanish-pos-dict-${dictVers}.jar
cp org/languagetool/resource/es/* morfologik-lt/
rm -rf org/
rm -rf META-INF/