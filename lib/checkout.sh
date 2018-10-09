checkout() {
  echo "ref: refs/heads/$2" > $gitf/HEAD
  echo "Switched to branch: "$cyan"$2"$white
  okfn
}
