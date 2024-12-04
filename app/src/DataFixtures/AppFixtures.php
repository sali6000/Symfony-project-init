<?php

namespace App\DataFixtures;

use App\Entity\Category;
use App\Entity\Product;
use Doctrine\Bundle\FixturesBundle\Fixture;
use Doctrine\Persistence\ObjectManager;

class AppFixtures extends Fixture
{
    public function load(ObjectManager $manager): void
    {
        // Création de la première catégorie
        $category1 = new Category();
        $category1->setName("Horreur");
        $manager->persist($category1); // Persist pour enregistrer dans le contexte de Doctrine

        // Création de la deuxième catégorie
        $category2 = new Category();
        $category2->setName("Comédie");
        $manager->persist($category2); // Persist pour enregistrer dans le contexte de Doctrine

        // Création du premier produit et association avec la première catégorie
        $product1 = new Product();
        $product1->setName("Baguette magique");
        $product1->setDescription("Harry Potter ? Nan");
        $product1->setPrice(25);
        $product1->setCategory($category1); // Association avec la catégorie "Horreur"
        $manager->persist($product1);

        // Création du deuxième produit et association avec la deuxième catégorie
        $product2 = new Product();
        $product2->setName("Chapeau rigolo");
        $product2->setDescription("Petit chapeau marrant");
        $product2->setPrice(12);
        $product2->setCategory($category2); // Association avec la catégorie "Comédie"
        $manager->persist($product2);

        // Enregistrement des entités dans la base de données
        $manager->flush();
    }
}
