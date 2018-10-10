checkout() {
  echo "ref: refs/heads/$2" > $head
  echo "Switched to branch: "$cyan"$2"$white
  okfn
}
